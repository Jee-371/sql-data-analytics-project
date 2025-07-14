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



-- Cumulative Analysis
-- Calculate total sales per month 
-- running total of sales over time
-- moving average price over time
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
    ) AS running_sales,
    AVG(average_price) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
    ) AS moving_average_price
FROM (
    SELECT
    DATETRUNC(month, order_date) as order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) AS t;


-- Perfomance Analysis
/* Analyse yearly perfomance of products by comparing the sales to 
both average sales and the previous year's salse of the product */
WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
    YEAR(f.order_date), p.product_name
)
SELECT 
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (
        PARTITION BY product_name
    ) AS avg_sales,
    current_sales - AVG(current_sales) OVER (
        PARTITION BY product_name
    ) AS diff_avg,
    CASE WHEN current_sales - AVG(current_sales) OVER (
             PARTITION BY product_name
         ) > 0 THEN 'Above Avg'
         WHEN current_sales - AVG(current_sales) OVER (
             PARTITION BY product_name
         ) < 0 THEN 'Below Avg'
         ELSE 'Avg'
    END avg_change,
    -- Year over Year Analysis
    LAG(current_sales) OVER (
        PARTITION BY product_name ORDER  BY order_year
        ) AS py_sales,
    current_sales - LAG(current_sales) OVER (
        PARTITION BY product_name ORDER  BY order_year
        ) AS diff_py,
    CASE WHEN current_sales - LAG(current_sales) OVER (
             PARTITION BY product_name ORDER  BY order_year
         ) > 0 THEN 'Increase in Sales'
         WHEN current_sales - LAG(current_sales) OVER (
             PARTITION BY product_name ORDER  BY order_year
         ) < 0 THEN 'Decrease in Sales'
         ELSE 'No Change'
     END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


-- Part to Whole Analysis
-- Which categories contribute to most overall sales
WITH category_sales AS(

    SELECT
        category,
        SUM(sales_amount) total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    GROUP BY category)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC


-- Data Segmentation
/* Segment products into cost range and find
   how many products fall in each segment */
WITH product_segments AS(
    SELECT
        product_key,
        product_name,
        cost,
        CASE WHEN cost < 100 THEN 'Below 100'
             WHEN cost BETWEEN 100 AND 500 THEN '100-500'
             WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
             ELSE 'Above 1000'
        END cost_range
    FROM gold.dim_products)
SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC


/* Group customers into three segments based on their spending behaviour.
    - VIP : Atleast 12 months of history and spent more that 5000
    - Regular : Atleast 12 months of history but spent less than 5000
    - New : Customers with lifespan less than 12 months
Find total customers in each group */
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) first_order,
        MAX(order_date) last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
    GROUP BY c.customer_key)
SELECT
customer_segment,
COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
             WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
             ELSE 'New'
        END customer_segment
    FROM customer_spending ) t
GROUP BY customer_segment
ORDER BY total_customers DESC
