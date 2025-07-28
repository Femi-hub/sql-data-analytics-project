/*
====================================================================================
📊 Purpose: Category-Wise Contribution to Overall Sales (with Percent of Total)
====================================================================================
This query calculates:
1. Total sales per product category
2. Each category's contribution to overall sales as a percentage
3. Final results sorted by percentage contribution in descending order

🧠 Key Concepts:
- Aggregation (`SUM`) by category
- Use of window function `SUM() OVER ()` to get total sales across all categories
- `CONCAT()` + `ROUND()` to format percentage values

📂 Source Tables:
- gold.fact_sales        -- Transactional sales data
- gold.dim_products      -- Product metadata including category

📌 Notes:
- `LEFT JOIN` ensures all sales are included even if product info is missing.
- `CAST` ensures floating-point division for accurate percentage.
*/

-- Final selection including category-level sales, total overall sales, and percent contribution
SELECT 
    *,  -- Select all fields from inner subquery
    SUM(total_sales) OVER () AS overall_sales,  -- Total sales across all categories (window function)
    
    -- Calculate each category’s percentage of overall sales and format as 'XX.XX%'
    CONCAT(
        ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2),
        '%'
    ) AS percentage_of_total

FROM (
    -- Inner query: Aggregate total sales per category
    SELECT 
        category,                           -- Product category
        SUM(s.sales_amount) AS total_sales -- Total revenue generated per category
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON p.product_key = s.product_key   -- Join to get category info
    GROUP BY category
) t

-- Sort results by percentage contribution in descending order
ORDER BY percentage_of_total DESC;
