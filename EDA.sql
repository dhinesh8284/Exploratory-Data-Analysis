-- sql-based exploratory data analysis on sales, customers, and products data -- 

CREATE DATABASE sales_dw;
USE sales_dw;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  order_number VARCHAR(20),
  product_key INT,
  customer_key INT,
  order_date DATE,
  shipping_date DATE,
  due_date DATE,
  sales_amount DECIMAL(10,2),
  quantity INT,
  price DECIMAL(10,2)
); -- data imported from csv files using data import wizard


DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_key INT,
  customer_id INT,
  customer_number VARCHAR(20),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  country VARCHAR(50),
  marital_status VARCHAR(20),
  gender VARCHAR(10),
  birthdate DATE,
  create_date DATE
);  -- data imported from csv files using data import wizard

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_key INT,
  product_id INT,
  product_number VARCHAR(20),
  product_name VARCHAR(100),
  category_id VARCHAR(20),
  category VARCHAR(50),
  subcategory VARCHAR(50),
  maintenance VARCHAR(10),
  cost DECIMAL(10,2),
  product_line VARCHAR(50),
  start_date DATE
);  -- data imported from csv files using data import wizard

-- Database Exploration --

SELECT COUNT(*) AS sales_rows FROM sales;
SELECT COUNT(*) AS customer_rows FROM customers;
SELECT COUNT(*) AS product_rows FROM products;


SELECT * FROM sales LIMIT 5;
SELECT * FROM customers LIMIT 5;
SELECT * FROM products LIMIT 5;


DESCRIBE sales;
DESCRIBE customers;
DESCRIBE products;

-- Data Quality Exploration                                    -- ensure data is reliable before analysis

-- Checking NULL values
select
count(*) as total_rows,
sum(order_date is null) as order_date_nulls,
sum(sales_amount is null) as sales_amount_nulls,
sum(quantity is null) as quantity_nulls,
sum(price is null) as price_nulls
from sales;

-- check for orphan sales records
select
count(*) as orphan_sales_records
from sales s
left join customers c
on s.customer_key = c.customer_key
where c.customer_key is null;

-- check for invalid sales, quantity, or price values
select
count(*) as invalid_sales_rows
from sales
where sales_amount <= 0
or quantity <= 0
or price <= 0;

-- check mismatch between calculated and stored sales amount
select count(*) as mismatched_sales
from sales
where abs(sales_amount - (price * quantity)) > 0.01;


-- DIMENSION EXPLORATION --                                           -- understand key business dimensions

-- Explore all countries our customers come from
select distinct country from customers;

-- exploring all categories & products " The Major Divisions"
select distinct category, subcategory, product_name from products
order by 1, 2, 3;


-- DATE EXPLORATION
 
 -- finding the first and last order date
 -- how many years of sales are available
 select min(order_date) as first_order,
 max(order_date) as last_order,
 timestampdiff(MONTH, min(order_date), max(order_date)) as range_of_MONTHS
 from sales;

-- Orders by Year 
select
year(order_date) as order_year,
count(distinct order_number) as total_orders
from sales
group by order_year
order by order_year;

 -- find the youngest and oldest customer
 
 select min(birthdate) as young_birthdate,
 timestampdiff(year, max(birthdate), curdate()) as youngest_customer,
 max(birthdate) as old_birthdate,
 timestampdiff(year, min(birthdate), curdate()) as oldest_customer
 from customers;
 
 -- MEASURES EXPLORATION                                                -- calculate core business metrics

-- Find the Total Sales
select sum(sales_amount) as total_sales from sales;

-- Find how many items are sold
select sum(quantity) as total_quantities_sold from sales;

-- Find the average selling price
select round(avg(price)) as avg_selling_price from sales;

-- Find the Total number of Orders
select count(distinct order_number) as total_orders from sales;

-- Find the total number of products
select count(product_key) as total_products from products;

-- Find the total number of customers
select count(customer_key) as total_customers from customers;

-- Customers who placed at least one order
select count(distinct customer_key) as active_customers from sales;

-- Avg Order value
select round(sum(sales_amount) / count(distinct order_number), 2) as avg_order_value
from sales;

-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, round(SUM(sales_amount)) AS measure_value FROM sales
UNION ALL
SELECT 'Total Quantity', round(SUM(quantity)) FROM sales
UNION ALL
SELECT 'Average Price', round(AVG(price)) FROM sales
UNION ALL
SELECT 'Total Nr. Orders', round(count(distinct order_number)) FROM sales
UNION ALL
SELECT 'Total Nr. Products', round(COUNT(product_name)) FROM products
UNION ALL
SELECT 'Total Nr. Customers', round(COUNT(customer_key)) FROM customers;

-- Magnitude analysis                                                           -- compare contribution across different segments

-- Find total customers by countries
select country,count(customer_key) as total_customers
from customers
group by country
order by 2 desc;

-- Find total customers by gender
select gender,count(customer_key) as total_customers
from customers
group by gender
order by 2 desc;

-- Find total products by category
select category, count(product_key) as total_products
from products
where category IS NOT NULL
group by 1
order by 2 desc;

-- What is the average costs in each category?
select category, round(avg(cost),2) as avg_cost
from products
where category IS NOT NULL
group by 1
order by 2 desc;

-- What is the total revenue generated for each category?
select p.category, sum(s.sales_amount) as total_sales
from sales s
left join
products p
on s.product_key = p.product_key
group by 1
order by 2 desc;

-- Find total revenue is generated by each customer
select c.customer_key, c.first_name, c.last_name, sum(s.sales_amount) as total_sales
from sales s
left join customers c
on s.customer_key = c.customer_key
where c.customer_key IS NOT NULL
group by 1,2,3
order by 4 desc;

-- What is the distribution of sold items across countries?
select c.country, sum(s.quantity) as total_quantities
from sales s
left join customers c
on s.customer_key = c.customer_key
group by 1
order by 2 desc;

-- Ranking Analysis                                                                 -- identify best and worst performing entities


-- TOP 3 Products in each Category with Highest Revenue ( Best Performing Products )

with cte1 as(
select p.category, p.product_name, sum(s.sales_amount) as total_revenue,
row_number() over(partition by p.category order by sum(s.sales_amount) desc) rnk
from sales s
join products p
on s.product_key = p.product_key
group by 1,2
)
select category,product_name,total_revenue
from cte1
where rnk<=3;


-- TOP 3 Products in Each Category with Lowest Revenue ( Worst Performing products )
with cte as(
select p.category, p.product_name, sum(s.sales_amount) as total_revenue,
row_number() over(partition by p.category order by sum(s.sales_amount)asc) rnk
from sales s
join products p
on s.product_key = p.product_key
group by 1,2
)
select category,product_name,total_revenue
from cte
where rnk <=3;

-- Top 10 customers with Highest Revenue
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM sales f
LEFT JOIN customers c
ON c.customer_key = f.customer_key
where c.customer_key IS NOT NULL
GROUP BY 1,2,3
ORDER BY total_revenue DESC
limit 10;

-- Top 5 customers with Lowest Orders
SELECT
c.customer_key,
c.first_name,
c.last_name,
count(f.quantity) AS total_quantity
FROM sales f
LEFT JOIN customers c
ON c.customer_key = f.customer_key
GROUP BY 1,2,3
ORDER BY total_quantity
limit 5;

-- end of exploratory data analysis

