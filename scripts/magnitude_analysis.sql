/*
=======================================================
📊 Purpose: Exploratory Data Analysis on Customers & Products
=======================================================
This script provides insights into:
1. Customer distribution by country and gender
2. Product distribution and average cost per category
3. Revenue breakdown by category and customer
4. Quantity sold per customer country

📦 Source Tables:
- gold.dim_customers      -- Customer demographic data
- gold.dim_products       -- Product catalog data
- gold.fact_sales         -- Sales transactions

📌 Notes:
- LEFT JOINs ensure no sales are excluded due to missing product/customer details.
- Aggregations (SUM, COUNT, AVG) used to compute metrics per group.
*/

-- 1. Count of Customers by Country
SELECT 
    country,                                 -- Customer's country
    COUNT(customer_key) AS total_customers   -- Number of customers per country
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;              -- Most populous countries first

-- 2. Count of Customers by Gender
SELECT 
    gender,                                  -- Gender classification
    COUNT(customer_key) AS gender_count      -- Number of customers by gender
FROM gold.dim_customers
GROUP BY gender
ORDER BY gender_count DESC;                 -- Highest gender count first

-- 3. Count of Products per Category
SELECT 
    category,                                -- Product category
    COUNT(product_key) AS product_count      -- Number of products in each category
FROM gold.dim_products
GROUP BY category
ORDER BY product_count DESC;                -- Most stocked categories first

-- 4. Average Cost per Product Category
SELECT 
    category,                                -- Product category
    AVG(cost) AS avg_cost                    -- Average cost within the category
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;                     -- Categories with most expensive products first

-- 5. Total Revenue by Product Category
SELECT 
    category,                                -- Product category
    SUM(s.sales_amount) AS total_revenue     -- Total revenue generated from each category
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
GROUP BY category
ORDER BY total_revenue DESC;                -- Most profitable categories first

-- 6. Total Revenue by Customer
SELECT 
    c.customer_key,                          -- Unique customer ID
    c.first_name,
    c.last_name,
    SUM(sales_amount) AS total_revenue       -- Total revenue from each customer
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;                -- Highest paying customers first

-- 7. Total Quantity Sold by Customer Country
SELECT 
    c.country,                               -- Customer country
    SUM(quantity) AS total_quantity          -- Total number of units sold in each country
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY c.country
ORDER BY total_quantity DESC;               -- Countries with highest unit sales first
