/*
==================================================================
📊 Purpose: Yearly and Monthly Product Revenue Trend Analysis
==================================================================
This script calculates and compares revenue performance of products over time:
1. Yearly total revenue per product with year-over-year difference & trend
2. Monthly total revenue per product with month-over-month difference & trend

🧠 Techniques Used:
- Common Table Expressions (CTEs) to isolate yearly and monthly aggregations
- `LAG()` window function to retrieve previous period’s revenue
- `CASE` logic to label revenue change direction (Increase, Decrease, No Change)

📂 Source Tables:
- gold.fact_sales         -- Contains transactional sales data
- gold.dim_products       -- Contains product metadata

📌 Notes:
- `LEFT JOIN` ensures all sales are included, even if product metadata is incomplete
- `PARTITION BY product_name` allows window functions to operate independently for each product
*/

----------------------------------------
-- 🔵 Yearly Product Trend Analysis
----------------------------------------

WITH yearly_product_sales AS
(
	SELECT YEAR(s.order_date) AS yearly_basis
		,p.product_name
		,SUM(s.sales_amount) AS total_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY p.product_name, YEAR(s.order_date)
)
SELECT yearly_basis
		,product_name
		,total_revenue
		,LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY yearly_basis) AS previous_year_sales
		,total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY yearly_basis) AS previous_year_difference
		,CASE
			WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY yearly_basis) > 0 THEN 'Increase'
			WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY yearly_basis) < 0 THEN 'Decrease'
			ELSE 'No Change'
		END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, yearly_basis;

-------------------------------------
-- 🔵 Monthly Product Trend Analysis
-------------------------------------

WITH monthly_product_sales AS
(
	SELECT DATETRUNC(MONTH, s.order_date) AS monthly_basis
		,p.product_name
		,SUM(s.sales_amount) AS total_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY p.product_name, DATETRUNC(MONTH, s.order_date)
)
SELECT monthly_basis
		,product_name
		,total_revenue
		,LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY monthly_basis) AS previous_month_sales
		,total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY monthly_basis) AS previous_month_difference
		,CASE
			WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY monthly_basis) > 0 THEN 'Increase'
			WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY monthly_basis) < 0 THEN 'Decrease'
			ELSE 'No Change'
		END AS previous_month_change
FROM monthly_product_sales
ORDER BY product_name, monthly_basis
