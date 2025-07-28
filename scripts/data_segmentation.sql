/*
===============================================================================
📊 Purpose: Product Segmentation by Cost & Customer Segmentation by Spending
===============================================================================
This script performs two segmentation tasks:

1. 📦 Product Segmentation:
   - Categorizes products into defined cost ranges.
   - Counts how many products fall into each cost segment.

2. 👥 Customer Segmentation:
   - Calculates customer lifetime value metrics such as:
     - First order date
     - Last order date
     - Total spend
     - Lifespan in months
   - Segments customers into groups: VIP, Regular, or New based on spend and lifespan.

📂 Source Tables:
- gold.dim_products       -- Contains product cost and identifiers
- gold.fact_sales         -- Contains transactional sales and customer keys

📌 Notes:
- Segmentation helps in understanding product pricing distribution and customer value levels.
- `CASE` expressions are used for bucketing products and customers.
- `DATEDIFF` in months is used to compute customer lifespan for segmentation logic.
*/

-- =============================================================================
-- 🔹 1. Product Segmentation by Cost Ranges
-- =============================================================================
WITH product_segments AS (
	SELECT 
		-- Define cost ranges for segmentation
		CASE
			WHEN cost < 100 THEN 'BELOW 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
			WHEN cost BETWEEN 501 AND 1000 THEN '501 - 1000'
			ELSE 'ABOVE 1000'
		END AS cost_range,
		product_key                                   -- Product identifier
	FROM gold.dim_products
)

-- Count total products in each cost segment
SELECT 
	cost_range,
	COUNT(product_key) AS total_products            -- Number of products in each segment
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;                      -- Show most common segments first

-- =============================================================================
-- 🔹 2. Customer Segmentation by Spend and Lifespan
-- =============================================================================
WITH customer_spending AS (
	SELECT 
		customer_key,
		MIN(order_date) AS first_order,              -- First recorded purchase
		MAX(order_date) AS last_order,               -- Most recent purchase
		SUM(sales_amount) AS total_spend,            -- Total customer spend
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan  -- Customer lifespan in months
	FROM gold.fact_sales
	GROUP BY customer_key
)

-- Apply segmentation logic and count customers per group
SELECT 
	segmented_customers,                            -- Segment label
	COUNT(customer_key) AS total_customers          -- Number of customers in each segment
FROM (
	SELECT 
		-- Segment customers based on spend and activity period
		CASE
			WHEN lifespan <= 12 AND total_spend > 5000 THEN 'VIP'       -- High spenders within a year
			WHEN lifespan <= 12 AND total_spend <= 5000 THEN 'Regular'  -- Lower spenders within a year
			ELSE 'New'                                                  -- Long inactive or newly active
		END AS segmented_customers,
		customer_key
	FROM customer_spending
) t
GROUP BY segmented_customers
ORDER BY total_customers DESC;                      -- Prioritize the most populated segments
