/*
===========================================================
📊 Purpose: Analyze Yearly Sales Trends with Window Metrics
===========================================================
This script computes yearly revenue trends, including:
1. Total revenue and average price per year
2. A cumulative running total of revenue across years
3. A moving average of yearly average prices

🏗️ Key Techniques:
- Use of `DATETRUNC(YEAR, order_date)` for yearly grouping
- Window functions (`SUM() OVER`, `AVG() OVER`) for cumulative and moving metrics

📂 Source Table:
- gold.fact_sales       -- Transactional sales data

📌 Notes:
- `DATETRUNC` ensures consistent yearly aggregation
- `WHERE` clause filters out NULL dates to avoid invalid groupings
- Results ordered by year to support correct window function computation
*/

-- Outer query with window functions for running total and moving average
SELECT 
    order_date,                                           -- Year of the order (truncated from order_date)
    total_revenue,                                        -- Total revenue for that year
    SUM(total_revenue) OVER (ORDER BY order_date) AS running_total_sales,  -- Cumulative revenue up to current year
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price      -- Moving average of average price over years
FROM (
    -- Inner query: Aggregate yearly revenue and average price
    SELECT 
        DATETRUNC(YEAR, order_date) AS order_date,        -- Truncate order date to year
        SUM(sales_amount) AS total_revenue,               -- Total revenue in the year
        AVG(price) AS avg_price                           -- Average product price in the year
    FROM gold.fact_sales
    WHERE DATETRUNC(YEAR, order_date) IS NOT NULL         -- Filter out rows with NULL dates
    GROUP BY DATETRUNC(YEAR, order_date)                  -- Group by year
) t;
