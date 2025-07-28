/*
Purpose:
This script is used for **data exploration** of the database structure. 
It performs the following:
1. Lists all tables available in the database along with their schema and type.
2. Retrieves column-level metadata for a specific table ('dim_customers') including whether columns allow NULLs.
*/

-- Query 1: List all tables in the database with their schema and type
SELECT 
	TABLE_CATALOG,    -- Name of the database
	TABLE_SCHEMA,     -- Schema the table belongs to (e.g., dbo, sales, etc.)
	TABLE_NAME,       -- Name of the table
	TABLE_TYPE        -- Type of table (e.g., BASE TABLE or VIEW)
FROM 
	INFORMATION_SCHEMA.TABLES;

-- Query 2: Explore column structure of the 'dim_customers' table
SELECT 
	TABLE_CATALOG,    -- Name of the database
	TABLE_SCHEMA,     -- Schema the table belongs to
	TABLE_NAME,       -- Table name (should be 'dim_customers' in this case)
	COLUMN_NAME,      -- Name of each column in the table
	IS_NULLABLE       -- Indicates whether each column allows NULL values
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'dim_customers';  -- Filter to only show metadata for 'dim_customers' table
