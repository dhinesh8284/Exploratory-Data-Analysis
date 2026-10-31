📊 SQL Exploratory Data Analysis (EDA)
📌 Project Overview
This project focuses on performing Exploratory Data Analysis (EDA) using MySQL on a sales dataset.
The main objective is to understand the structure, quality, and behavior of data before moving to dashboards or advanced analytics.

The analysis is performed entirely using SQL to demonstrate strong data understanding, querying skills, and analytical thinking.

📂 Dataset Description
The project uses three related datasets:

🧾 Sales
Contains transactional sales data
Includes order details, sales amount, quantity, price, and order dates
Acts as the fact table
👥 Customers
Contains customer demographic information
Includes country, gender, marital status, and birthdate
Acts as a dimension table
🏷️ Products
Contains product-level details
Includes product name, category, subcategory, cost, and product line
Acts as a dimension table
The datasets follow a fact–dimension structure:

Sales → Fact table
Customers & Products → Dimension tables
🛠️ Tools & Technologies
MySQL
MySQL Workbench
📌 Data was imported from CSV files using the MySQL Workbench Data Import Wizard.

🔍 Analysis Workflow
The exploratory data analysis was carried out in a structured manner using the following steps:

1️⃣ Database Exploration
Verified successful data import
Checked row counts for all tables
Reviewed table structure and data types
Inspected sample records to understand the data
2️⃣ Data Quality Exploration
Checked for missing (NULL) values in key columns
Identified orphan sales records without matching customers
Validated business logic by detecting invalid sales, quantity, or price values
✅ This step ensured data reliability before further analysis.

3️⃣ Dimension Exploration
Explored customer distribution across countries
Reviewed product categories, subcategories, and product names
Understood key business dimensions used for analysis
4️⃣ Date Exploration
Identified the first and last order dates
Calculated the total time range covered by the dataset
Analyzed customer age extremes using birthdate information
5️⃣ Measure Exploration
Calculated total sales revenue
Calculated total quantity sold
Computed average selling price
Calculated total number of orders
Identified total and active customers
6️⃣ Magnitude Analysis
Analyzed customer distribution by country and gender
Analyzed product distribution by category
Calculated average product cost by category
Analyzed revenue contribution by category and by customer
Evaluated quantity sold across countries
7️⃣ Ranking Analysis
Identified Top 3 best-performing products in each category
Identified Bottom 3 worst-performing products in each category
Identified Top customers by revenue
Identified customers with the lowest number of orders
📌 Window functions and Common Table Expressions (CTEs) were used for ranking analysis.

📈 Key Insights
Customer and product performance varies significantly across categories and regions
A small group of products and customers contribute a large portion of total revenue
Data quality checks helped ensure accurate and reliable analysis
SQL alone is sufficient to derive meaningful business insights during the EDA stage
🎯 Project Outcome
This project demonstrates:

Strong understanding of Exploratory Data Analysis concepts
Ability to assess data quality before analysis
Proficiency in SQL joins, aggregations, CTEs, and window functions
Structured and business-oriented analytical thinking
🤝 Connect With Me
🔗 LinkedIn: www.linkedin.com/in/dhineshkumar8284
📝 Note
This project focuses only on exploratory analysis.
Advanced data cleaning, feature engineering, and visualization are intentionally kept outside the scope of this project.

