-- Exploring Measures
-- Find Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- How Many Items are Sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find Average Selling Price
SELECT AVG(price) AS average_price FROM gold.fact_sales

-- Total Number of Orders
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
