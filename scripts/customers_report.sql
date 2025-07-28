/*
====================================================================================
📊 Purpose: Create `gold.report_customers` View for Customer Analytics & Segmentation
====================================================================================
This SQL view provides enriched customer-level analytics for reporting and segmentation.
It aggregates customer behavior over time and derives attributes useful for business decisions:
- Age group classification
- Lifecycle metrics: lifespan, recency
- Behavioral metrics: order count, quantity, spend, product diversity
- Segmentation: VIP, Regular, New
- Derived KPIs: average monthly spend, average order value

🧠 Key Concepts:
- CTEs for intermediate calculations
- Windowed aggregates using GROUP BY
- Conditional logic via CASE expressions

📂 Source Tables:
- gold.fact_sales       -- Transaction-level sales data
- gold.dim_customers    -- Customer demographic information

📌 Output: A summarized, report-ready customer dataset in the `gold` schema
*/

-- Drop existing view if it exists
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

-- Create the customer report view
CREATE VIEW gold.report_customers AS

-- Step 1: Base table with joined customer and sales data
WITH base_table AS (
	SELECT 
		s.order_date,                            -- Date of order
		s.order_number,                          -- Unique order ID
		s.sales_amount,                          -- Revenue from the order
		s.quantity,                              -- Quantity sold
		s.product_key,                           -- Product sold
		c.customer_key,                          -- Unique customer ID
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name, -- Full name
		DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age            -- Customer age
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = s.customer_key
),

-- Step 2: Aggregated metrics per customer
customer_aggregation AS (
	SELECT 
		customer_key,
		customer_name,
		age,
		MAX(order_date) AS last_order_date,                         -- Most recent purchase
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan, -- Active span in months
		COUNT(DISTINCT order_number) AS order_count,               -- Total unique orders
		SUM(sales_amount) AS total_spend,                          -- Total amount spent
		SUM(quantity) AS total_quantity,                           -- Total quantity bought
		COUNT(DISTINCT product_key) AS total_products              -- Unique products purchased
	FROM base_table
	GROUP BY customer_key, customer_name, age
)

-- Step 3: Final report with segmentation and derived KPIs
SELECT 
	customer_key,
	customer_name,

	-- Age group buckets
	CASE
		WHEN age < 20 THEN 'BELOW 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE 'ABOVE 50'
	END AS age_group,

	lifespan,                                        -- Customer active period (in months)
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency, -- Months since last purchase
	order_count,                                     -- Total distinct orders
	total_spend,                                     -- Total amount spent

	-- Segment customers based on spend and lifespan
	CASE
		WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spend < 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segments,

	total_quantity,                                  -- Units purchased
	total_products,                                  -- Unique product variety

	-- Average monthly spend (handling division by 0)
	CASE 
		WHEN lifespan = 0 THEN total_spend
		ELSE total_spend / lifespan
	END AS average_monthly_spend,

	-- Average order value (handling division by 0)
	CASE
		WHEN order_count = 0 THEN total_spend / NULLIF(order_count, 0)
		ELSE total_spend / order_count
	END AS average_order_value

FROM customer_aggregation;
