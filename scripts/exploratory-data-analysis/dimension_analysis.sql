-- Meta Data of Tables
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Meta Data of Columns
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- Exploring Dimensions
SELECT DISTINCT country FROM gold.dim_customers

-- Finding Divisions and Subdivisions
SELECT DISTINCT category,subcategory, product_name FROM gold.dim_products
ORDER By 1,2,3
