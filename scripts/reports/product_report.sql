/*
Product Report

Purpose: Consolidate key product metrics and behaviours

Highlights: 
	1. Gather product name, category, subcategory and cost
	2. Segment products by revenue to identify perfomance level
	3. Aggregate:
		- total orders
		- total sales
		- total quantity sold
		- total customers
		- lifespan
	4. Calculate valuable KPIs:
		- recency
		- average order revenue
		- average monthly revenue

*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
-- Base Query : Retrieve the core columns from tables
	SELECT
		f.order_number,
		f.customer_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL )

, product_aggregation AS (
-- Product Aggregation : Summarizes key metrics at the product level
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
		MAX(order_date) AS last_order_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) AS avg_selling_price
		
	FROM base_query
	GROUP By 
		product_key,
		product_name,
		category,
		subcategory,
		cost
)
-- Final Query : Combine all customer results into one output
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(month,last_order_date,GETDATE()) AS recency_in_months,
	lifespan,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END AS product_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/ total_orders
	END AS avg_order_revenue,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales/ lifespan
	END AS avg_monthly_revenue
FROM product_aggregation
