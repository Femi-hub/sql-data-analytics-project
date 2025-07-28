/*
Purpose:
This SQL script sets up a clean data warehouse environment using SQL Server.
It performs the following steps:
1. Drops and recreates the 'NewDataAnalytics' database.
2. Creates the 'gold' schema to hold curated data.
3. Defines dimension and fact tables: dim_customers, dim_products, and fact_sales.
4. Loads data into the tables from local CSV files using BULK INSERT.

This setup is typically used in a data warehousing context to support analytics, reporting, and business intelligence tasks.
*/

-- Switch to the 'master' database
USE master;
GO

-- Drop the database if it already exists to ensure a fresh setup
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'NewDataAnalytics')
BEGIN
    -- Forcefully disconnect users before dropping the database
    ALTER DATABASE NewDataAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NewDataAnalytics;
END;
GO

-- Create a new, clean version of the database
CREATE DATABASE NewDataAnalytics;
GO

-- Switch context to the newly created database
USE NewDataAnalytics;
GO

-- Create a schema named 'gold' to store curated, analytics-ready tables
CREATE SCHEMA gold;
GO

-- Create customer dimension table in the 'gold' schema
CREATE TABLE gold.dim_customers (
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

-- Create product dimension table in the 'gold' schema
CREATE TABLE gold.dim_products (
	product_key int,
	product_id int,
	product_number nvarchar(50),
	product_name nvarchar(50),
	category_id nvarchar(50),
	category nvarchar(50),
	subcategory nvarchar(50),
	maintenance nvarchar(50),
	cost int,
	product_line nvarchar(50),
	start_date date
);
GO

-- Create fact table to hold sales transaction data
CREATE TABLE gold.fact_sales (
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int
);
GO

-- Truncate existing data in the customer dimension table (if any)
TRUNCATE TABLE gold.dim_customers;
GO

-- Load customer dimension data from CSV file
BULK INSERT gold.dim_customers
FROM 'C:\Users\BIZMARROW\Desktop\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,             -- Skip header row
	FIELDTERMINATOR = ',',    -- Use comma as field delimiter
	TABLOCK                   -- Use table-level lock for performance
);
GO

-- Truncate existing data in the product dimension table (if any)
TRUNCATE TABLE gold.dim_products;
GO

-- Load product dimension data from CSV file
BULK INSERT gold.dim_products
FROM 'C:\Users\BIZMARROW\Desktop\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Truncate existing data in the sales fact table (if any)
TRUNCATE TABLE gold.fact_sales;
GO

-- Load sales fact data from CSV file
BULK INSERT gold.fact_sales
FROM 'C:\Users\BIZMARROW\Desktop\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
