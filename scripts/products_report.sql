/*
===========================================================================================
🎯 PURPOSE: Product Sales Performance Aggregation Report
===========================================================================================

This script generates a product-level sales performance report using data from 
`gold.fact_sales` and `gold.dim_products`. It computes key metrics to help stakeholders 
analyze product performance over time, including:

- Total number of orders and distinct customers
- Total and average monthly sales
- Average order value
- Total and average quantity sold
- Category and subcategory breakdowns
- Sales period duration in months

These insights are crucial for understanding sales trends, product popularity, 
and revenue contribution across the product catalog.

-------------------------------------------------------------------------------------------
📁 Tables Used:
  - gold.fact_sales       → Contains transactional sales records
  - gold.dim_products     → Contains product metadata

🛠️ Key Metrics Calculated:
  - `total_sales`                  → Sum of all sales per product
  - `average_monthly_sales`       → Sales spread evenly across months sold
  - `average_order_value`         → Revenue per unique order
  - `average_sales_per_quantity`  → Sales amount per unit sold
  - `total_customers`             → Reach per product

📦 Output:
  One row per product, with performance indicators to support business decisions in 
  product management, marketing, inventory planning, and strategic analysis.

===========================================================================================
*/

-- Create a base table that joins sales data with product information
WITH base_table AS (
	SELECT 
		s.order_date,           -- Date of each order
		s.order_number,         -- Unique identifier for each order
		s.sales_amount,         -- Revenue generated from the order
		s.quantity,             -- Quantity of products sold
		s.customer_key,         -- Identifier for the customer
		p.product_key,          -- Identifier for the product
		p.category,             -- Product category
		p.subcategory,          -- Product subcategory
		p.product_name          -- Product name
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
		ON p.product_key = s.product_key
),

-- Aggregate metrics at the product level
product_aggregation AS (
	SELECT 
		product_key,
		category,
		subcategory,
		product_name,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS no_of_months,         -- Span of months with sales
		COUNT(DISTINCT order_number) AS order_count,                                -- Total unique orders
		SUM(sales_amount) AS total_sales,                                           -- Total revenue
		SUM(quantity) AS total_quantity,                                            -- Total quantity sold
		COUNT(DISTINCT customer_key) AS total_customers                             -- Number of distinct customers
	FROM base_table
	GROUP BY 
		product_key,
		category,
		subcategory,
		product_name
)

-- Final selection and calculation of KPIs
SELECT 
	product_key,
	category,
	subcategory,
	product_name,
	no_of_months,
	order_count,
	total_sales,

	-- Average monthly sales (handles divide-by-zero if no_of_months = 0)
	CASE 
		WHEN no_of_months = 0 THEN total_sales
		ELSE total_sales / no_of_months
	END AS average_monthly_sales,

	-- Average order value (NULL-safe division)
	total_sales / NULLIF(order_count, 0) AS average_order_value,
	total_quantity,

	-- Average sales per unit quantity (NULL-safe division)
	total_sales / NULLIF(total_quantity, 0) AS average_sales_per_quantity,

	total_customers
FROM product_aggregation;
