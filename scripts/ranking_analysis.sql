/*
=======================================
🚀 Purpose: Top Products and Customers Analysis
=======================================
This script performs data exploration to identify:
1. Top 5 best-selling products by sales amount.
2. Top 3 highest-paying customers.
3. Bottom 3 customers by number of distinct orders.
4. A ranked list using ROW_NUMBER() to retrieve the top 5 products by sales.

📂 Source Tables:
- gold.fact_sales         -- Transactional sales data
- gold.dim_products       -- Product dimension
- gold.dim_customers      -- Customer dimension

📌 Notes:
- LEFT JOIN ensures that all sales are considered even if related product or customer info is missing.
- Aggregations use SUM or COUNT as needed.
- Sorting is applied for ranking purposes.
*/

-- 1. Top 5 Products by Sales Amount 
SELECT TOP 5 
    p.product_name,
    SUM(s.sales_amount) AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY sales_amount DESC;  -- Highest sales first

-- 2. Bottom 5 Products by Sales Amount 
SELECT TOP 5 
    p.product_name,
    SUM(s.sales_amount) AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY sales_amount;  -- Lowest sales first

-- 3. Top 3 Customers by Total Sales Amount
SELECT TOP 3 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY sales_amount DESC;  -- Highest spenders

-- 4. Bottom 3 Customers by Number of Unique Orders
SELECT TOP 3 
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT s.order_number) AS sales_order
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY sales_order;  

-- 5. Top 5 Products by Sales Using ROW_NUMBER()
SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM(s.sales_amount) AS sales_amount,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS ranking  -- Ranking products by sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON p.product_key = s.product_key
    GROUP BY p.product_name
) t
WHERE ranking <= 5;  -- Select only top 5 products
