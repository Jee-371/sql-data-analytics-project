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
