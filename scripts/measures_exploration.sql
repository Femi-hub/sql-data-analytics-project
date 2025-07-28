/*
===============================================================================
KPI Exploration – Sales and Dimensional Metrics
===============================================================================
Purpose:
    - To calculate key aggregated measures (KPIs) from the fact and dimension tables.
    - To provide a quick snapshot of total sales, volume, price, order count, 
      customer count, and product count for dashboarding or reporting.

SQL Functions Used:
    - SUM(), AVG(), COUNT(), COUNT(DISTINCT)
    - UNION ALL to stack results vertically

Tables Involved:
    - gold.fact_sales
    - gold.dim_customers
    - gold.dim_products
===============================================================================
*/

SELECT 'Total Sales' AS Dimension, SUM(sales_amount) AS Measure FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'Total Products', COUNT(product_key) FROM gold.dim_products;
