-- Change Over Time Analysis (Trend)
SELECT 
YEAR(order_date) as order_year, 
MONTH(order_date) as order_month, 
SUM(sales_amount) as total_sales, 
COUNT(DISTINCT customer_key) as total_customers, 
SUM(quantity) as total_quantity 
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date), MONTH(order_date) 
ORDER BY YEAR(order_date), MONTH(order_date)

-- Using Datetrunc
SELECT 
DATETRUNC(year, order_date) as order_date, 
SUM(sales_amount) as total_sales, 
COUNT(DISTINCT customer_key) as total_customers, 
SUM(quantity) as total_quantity 
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY DATETRUNC(year, order_date) 
ORDER BY DATETRUNC(year, order_date)

-- Using Format
SELECT 
FORMAT(order_date, 'yyyy-MMM') as order_date, 
SUM(sales_amount) as total_sales, 
COUNT(DISTINCT customer_key) as total_customers, 
SUM(quantity) as total_quantity 
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')
