USE master;
GO
IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWarehouse'
BEGIN
	ALTER DATABASE DataAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataAnalytics;
END;
GO

CREATE DATABASE DataAnalytics;
GO

USE DataAnalytics;
GO

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
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

CREATE TABLE gold.dim_products(
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

CREATE TABLE gold.fact_sales(
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

IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO

SELECT *
INTO gold.dim_customers
FROM DataWarehouse.gold.dim_customers;
GO

IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO

SELECT *
INTO gold.dim_products
FROM DataWarehouse.gold.dim_products;
GO

IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

SELECT *
INTO gold.fact_sales
FROM DataWarehouse.gold.fact_sales;
GO
