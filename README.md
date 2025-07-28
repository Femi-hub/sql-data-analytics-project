🧠 SQL Sales Analytics Project

📌 Overview
This project explores and analyzes a sales database using SQL Server. It covers the full analytics workflow — from database initialization to advanced reporting. The queries provide deep insights into product performance, customer behavior, time-based trends, segmentation, and overall business performance.

🏗️ Project Structure

🧱 Database
All data resides in the NewDataAnalytics SQL Server database under the gold schema, structured for analytics using a star schema (fact and dimension tables).

🔹 Database Exploration
View available tables and schemas
Inspect column metadata, data types, and nullability

SELECT * FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dim_customers';

🔍 Data Exploration & Analysis

🔹 Dimension Exploration
Explore unique values in key dimensions: customers, products, countries, categories, etc.

SELECT DISTINCT country FROM gold.dim_customers;
SELECT DISTINCT category FROM gold.dim_products;

🔹 Date-Range Exploration
Get the earliest and latest order dates
Measure sales data coverage over time

SELECT MIN(order_date), MAX(order_date) FROM gold.fact_sales;

📏 Measures & Metrics
🔹 Measures Exploration
Total revenue, average price, total quantity
Measures at different aggregation levels (monthly, yearly)

SELECT SUM(sales_amount), AVG(price), SUM(quantity) FROM gold.fact_sales;

🔹 Magnitude Analysis
Measure product sales, customer revenue, and category sales magnitude

SELECT product_name, SUM(sales_amount) FROM gold.fact_sales GROUP BY product_name;

🔹 Ranking Analysis
Top-N products or customers by sales
Use of ROW_NUMBER() for flexible ranking

SELECT TOP 5 product_name, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY product_name
ORDER BY total_sales DESC;

📈 Time-Based Trends
🔹 Change Over Time Analysis
Year-over-year and month-over-month comparison
Use of LAG() to detect revenue growth/decline

SELECT 
    YEAR(order_date) AS year,
    SUM(sales_amount) AS total_revenue,
    LAG(SUM(sales_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year
FROM gold.fact_sales
GROUP BY YEAR(order_date);

🔹 Cumulative Analysis
Running total of revenue or sales
Use of SUM() OVER (ORDER BY date) for cumulative metrics

SELECT 
    order_date,
    SUM(sales_amount) OVER (ORDER BY order_date) AS running_total
FROM gold.fact_sales;

🔹 Performance Analysis
Compare average price, total quantity, and total revenue across time and categories

SELECT category, AVG(price), SUM(quantity), SUM(sales_amount)
FROM gold.fact_sales s
JOIN gold.dim_products p ON s.product_key = p.product_key
GROUP BY category;

🧬 Data Segmentation
🔹 Customer & Product Segmentation
Segment customers by lifespan and total spend (VIP, Regular, New)
Segment products by cost brackets

CASE WHEN total_spend > 5000 THEN 'VIP' ELSE 'Regular' END AS customer_segment

🧩 Part-to-Whole Analysis
🔹 Category Contribution to Total Sales
Calculate each category's % of overall revenue using window functions

SELECT 
    category,
    SUM(sales_amount),
    CONCAT(ROUND((SUM(sales_amount)*100.0) / SUM(SUM(sales_amount)) OVER (), 2), '%') AS percent_total
FROM gold.fact_sales
GROUP BY category;

📋 Final Reports
🔹 Customers & Products Reports
Generate detailed reports per customer and product
Combine revenue, order counts, and ranking information

SELECT customer_key, first_name, last_name, SUM(sales_amount) AS total_spend
FROM gold.fact_sales
JOIN gold.dim_customers ON gold.fact_sales.customer_key = gold.dim_customers.customer_key
GROUP BY customer_key, first_name, last_name;

🚀 Technologies Used
SQL Server
T-SQL
Window Functions, Aggregates, Joins
Star Schema Design

🧑‍💻 Author
Oluwafemi Popoola
Analytics and Data Science Trainer
Expert in Product Performance, Customer Analytics, Predictive Modeling
📧 oluwafemipopoola00@gmail.com






