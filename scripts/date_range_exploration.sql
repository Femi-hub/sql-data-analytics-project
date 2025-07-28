/*
===============================================================================
Date and Customer Demographic Exploration
===============================================================================
Purpose:
    - To determine the temporal boundaries of sales transactions.
    - To understand the age range of customers based on birthdates.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF(), GETDATE()

Tables Involved:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Get the earliest and latest order dates from the sales fact table
-- Also calculate the number of months between them as the order range
SELECT 
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range
FROM 
    gold.fact_sales;

-- Get the oldest customer birthdate and compute their age as of today
SELECT 
    MIN(birthdate) AS oldest_customer, 
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_customer  -- (optional) Also include youngest for range
FROM 
    gold.dim_customers;

