-- Meta Data of Tables
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Meta Data of Columns
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- Exploring Dimensions
SELECT DISTINCT country FROM gold.dim_customers

-- Finding Divisions and Subdivisions
SELECT DISTINCT category,subcategory, product_name FROM gold.dim_products
ORDER By 1,2,3

-- Exploring Dates
-- Finding the oldest and latest orders and range of orders
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales

-- Finding the youngest and oldest customer
SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers

-- Exploring Measures
--Find Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- How Many Items are Sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find Average Selling Price
SELECT AVG(price) AS average_price FROM gold.fact_sales

--Total Number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Total Number of Products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products

-- Total Number of Customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Total Number of Customers who placed an Order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales

-- Report With all Business Metrics
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' as measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders' as measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Customers' as measure_name, COUNT(customer_key) AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Nr. Products' as measure_name, COUNT(product_key) AS measure_value FROM gold.dim_products

-- Magnitude
-- Total Number of Customers By Countries
SELECT
country,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

-- Total Number of Customers By Gender
SELECT
gender,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Total Products By Category
SELECT
category,
COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- Average Cost in Each Category
SELECT
category,
AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC

-- Total Revenue from Each Category
SELECT
p.category,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

-- Total Revenue By Each Customer
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

-- Distribution of Sold Items By Countries
SELECT
c.country,
SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.country
ORDER BY total_sold_items DESC

-- Ranking Analysis
-- Top 5 products with highest revenue
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- Alternate with Window
SELECT * FROM(
	SELECT
	p.product_name,
	SUM(f.sales_amount) AS total_revenue,
	RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name
)t WHERE rank_products <= 5

-- 5 Worst Performing Products
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- Top 10 Customers with Highest Revenue
SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

-- 3 Customers with Fewest Orders Placed
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders
