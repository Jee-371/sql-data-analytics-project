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
