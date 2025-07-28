/*
===============================================================================
Time Series Exploration – Yearly and Monthly Sales Trends
===============================================================================
Purpose:
    - To analyze sales trends over time by aggregating sales amounts.
    - To support trend analysis for reporting and dashboarding (e.g., year-over-year or month-over-month performance).

SQL Functions Used:
    - YEAR(), DATETRUNC(), SUM(), GROUP BY, ORDER BY

Tables Involved:
    - gold.fact_sales
===============================================================================
*/

-- =============================
-- Yearly Sales Trend Analysis
-- =============================
SELECT 
    YEAR(order_date) AS yearly_basis,        -- Extracts the year from the order date
    SUM(sales_amount) AS total_sales         -- Aggregates total sales for each year
FROM 
    gold.fact_sales
WHERE 
    YEAR(order_date) IS NOT NULL             -- Filters out rows with null year
GROUP BY 
    YEAR(order_date)                         -- Groups data by year
ORDER BY 
    YEAR(order_date);                        -- Orders results chronologically


-- ==============================
-- Monthly Sales Trend Analysis
-- ==============================
SELECT 
    DATETRUNC(MONTH, order_date) AS monthly_basis,  -- Truncates order date to the month level
    SUM(sales_amount) AS total_sales                -- Aggregates total sales for each month
FROM 
    gold.fact_sales
WHERE 
    DATETRUNC(MONTH, order_date) IS NOT NULL        -- Filters out rows with null month
GROUP BY 
    DATETRUNC(MONTH, order_date)                    -- Groups data by month
ORDER BY 
    DATETRUNC(MONTH, order_date);                   -- Orders results chronologically
