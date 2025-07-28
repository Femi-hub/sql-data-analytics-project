/*
Purpose:
This script is part of a data exploration process to understand the distinct values in key dimension tables.
1. It retrieves a list of all unique countries from the customer dimension table.
2. It retrieves all unique product combinations by category, subcategory, and product name from the product dimension table.
*/

-- Query 1: Get a list of all distinct countries from the customer dimension table
SELECT DISTINCT 
	country               -- Unique country values where customers are located
FROM 
	gold.dim_customers
ORDER BY 
	country;              -- Sort the result alphabetically by country

-- Query 2: Get unique product entries grouped by category and subcategory
SELECT DISTINCT 
	category,             -- High-level grouping of products (e.g., Electronics)
	subcategory,          -- Sub-group within the category (e.g., Phones)
	product_name          -- Specific product name
FROM 
	gold.dim_products
ORDER BY 
	category, subcategory, product_name;  -- Sort results hierarchically
