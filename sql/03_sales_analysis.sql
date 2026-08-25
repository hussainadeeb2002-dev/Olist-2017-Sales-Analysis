/*
=========================================================
Sales Performance Analysis
Project: Olist E-commerce Dataset
Author: Adeeb Hussain

Business Objective:
Analyze Olist's sales performance during 2017 and identify
the key drivers behind changes in revenue, including order
volume, order value, customer growth, geographic
contribution, and product category performance.

=========================================================
*/

-- Business Question 1: What was Olist's total revenue in 2017?

SELECT
    ROUND(SUM(items.price + items.freight_value),2) AS total_2017_revenue
FROM `sales-analysis-olist.olist.orders` AS orders
INNER JOIN `sales-analysis-olist.olist.order_items` AS items
    ON orders.order_id = items.order_id
WHERE orders.order_status = 'delivered'
  AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31';

-- Business Question 2: What was the monthly revenue in 2017?

SELECT
    DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
    ROUND(SUM(items.price + items.freight_value),2) AS monthly_revenue
FROM `sales-analysis-olist.olist.orders` AS orders
INNER JOIN `sales-analysis-olist.olist.order_items` AS items
    ON orders.order_id = items.order_id
WHERE orders.order_status = 'delivered'
  AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
GROUP BY month
ORDER BY month;

-- Business Question 3: What was the change in monthly revenue for 2017?

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
        ROUND(SUM(items.price + items.freight_value),2) AS monthly_revenue
    FROM `sales-analysis-olist.olist.order_items` AS items
    INNER JOIN `sales-analysis-olist.olist.orders` AS orders
        ON items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY month
),
previous_month_sales AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(monthly_revenue - previous_month_revenue,2) AS revenue_change,
    ROUND(SAFE_DIVIDE(monthly_revenue - previous_month_revenue,previous_month_revenue) * 100,2) AS revenue_change_pct
FROM previous_month_sales
ORDER BY month;

-- Business Question 4: What was the change in total monthly orders during 2017?

WITH monthly_orders AS (
    SELECT
        DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
        COUNT(DISTINCT orders.order_id) AS total_orders
    FROM `sales-analysis-olist.olist.orders` AS orders
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY month
)

SELECT
    month,
    total_orders,
    LAG(total_orders) OVER (ORDER BY month) AS previous_month_orders,
    total_orders - LAG(total_orders) OVER (ORDER BY month) AS order_change
FROM monthly_orders
ORDER BY month;

-- Business Question 5: What was the change in Average Order Value (AOV) during 2017?

WITH monthly_aov AS (
    SELECT
        DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
        ROUND(SUM(items.price + items.freight_value)/COUNT(DISTINCT items.order_id),2) AS average_order_value
    FROM `sales-analysis-olist.olist.order_items` AS items
    INNER JOIN `sales-analysis-olist.olist.orders` AS orders
        ON items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY month
)
SELECT
    month,
    average_order_value,
    LAG(average_order_value) OVER (ORDER BY month) AS previous_month_aov,
    ROUND(average_order_value - LAG(average_order_value) OVER (ORDER BY month),2) AS aov_change
FROM monthly_aov
ORDER BY month;

-- Business Question 6: What was the change in the number of unique customers placing orders each month during 2017?

WITH monthly_customers AS (
    SELECT
        DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
        COUNT(DISTINCT customers.customer_unique_id) AS total_customers
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.customers` AS customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY month
)
SELECT
    month,
    total_customers,
    LAG(total_customers) OVER (ORDER BY month) AS previous_month_customers,
    total_customers - LAG(total_customers) OVER (ORDER BY month) AS change_in_customers
FROM monthly_customers
ORDER BY month;

-- Business Question 7: Were the customers placing orders in 2017 primarily new or repeat customers?

WITH customer_first_order AS (
    SELECT
        customers.customer_unique_id,
        MIN(DATE(orders.order_purchase_timestamp)) AS first_order_date
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.customers` AS customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_unique_id
),
monthly_customer_type AS (
    SELECT
        DATE_TRUNC(DATE(orders.order_purchase_timestamp),MONTH) AS month,
        customers.customer_unique_id,
        CASE
            WHEN DATE(orders.order_purchase_timestamp) = customer_first_order.first_order_date THEN 'New Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.customers` AS customers
        ON orders.customer_id = customers.customer_id
    INNER JOIN customer_first_order
        ON customers.customer_unique_id = customer_first_order.customer_unique_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
)

SELECT
    month,
    customer_type,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM monthly_customer_type
GROUP BY
    month,
    customer_type
ORDER BY
    month,
    customer_type;

-- Business Question 8: Which states contributed the most to Olist's unique customer base in 2017?

WITH state_customers AS (
    SELECT
        customers.customer_state AS state,
        COUNT(DISTINCT customers.customer_unique_id) AS total_unique_customers
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.customers` AS customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY state
)
SELECT
    state,
    total_unique_customers,
    ROUND(SAFE_DIVIDE(total_unique_customers,SUM(total_unique_customers) OVER ()) * 100,2) AS customer_contribution_pct
FROM state_customers
ORDER BY total_unique_customers DESC;

-- Business Question 9: Which states contributed the most to Olist's total revenue in 2017?

WITH state_revenue AS (
    SELECT
        customers.customer_state AS state,
        ROUND( SUM(items.price + items.freight_value),2) AS total_revenue
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.order_items` AS items
        ON items.order_id = orders.order_id
    INNER JOIN `sales-analysis-olist.olist.customers` AS customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY state
)
SELECT
    state,
    total_revenue,
    ROUND(SAFE_DIVIDE(total_revenue, SUM(total_revenue) OVER ()) * 100,2) AS revenue_contribution_pct
FROM state_revenue
ORDER BY total_revenue DESC;

-- Business Question 10: Which product categories contributed the most to Olist's total revenue in 2017?

WITH category_revenue AS (
    SELECT
        category_translation.string_field_1 AS category,
        ROUND(SUM(items.price + items.freight_value),2) AS total_revenue
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.order_items` AS items
        ON orders.order_id = items.order_id
    INNER JOIN `sales-analysis-olist.olist.products` AS products
        ON items.product_id = products.product_id
    INNER JOIN `sales-analysis-olist.olist.category_translation` AS category_translation
        ON products.product_category_name =
           category_translation.string_field_0
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY category
)
SELECT
    category,
    total_revenue,
    ROUND(SAFE_DIVIDE(total_revenue,SUM(total_revenue) OVER ()) * 100,2) AS revenue_contribution_pct
FROM category_revenue
ORDER BY total_revenue DESC;

-- Business Question 11: Did the product categories that generated the most revenue also have the highest sales volume in 2017?

WITH category_performance AS (
    SELECT
        category_translation.string_field_1 AS category,
        ROUND(SUM(items.price + items.freight_value),2) AS total_revenue,
        COUNT(*) AS total_items_sold
    FROM `sales-analysis-olist.olist.orders` AS orders
    INNER JOIN `sales-analysis-olist.olist.order_items` AS items
        ON orders.order_id = items.order_id
    INNER JOIN `sales-analysis-olist.olist.products` AS products
        ON items.product_id = products.product_id
    INNER JOIN `sales-analysis-olist.olist.category_translation` AS category_translation
        ON products.product_category_name = category_translation.string_field_0
    WHERE orders.order_status = 'delivered'
      AND DATE(orders.order_purchase_timestamp) BETWEEN DATE '2017-01-01' AND DATE '2017-12-31'
    GROUP BY category
)
SELECT
    category,
    total_revenue,
    total_items_sold,
    ROUND(SAFE_DIVIDE(total_revenue,SUM(total_revenue) OVER ()) * 100,2) AS revenue_contribution_pct,
    ROUND(SAFE_DIVIDE(total_items_sold,SUM(total_items_sold) OVER ()) * 100,2) AS item_volume_contribution_pct
FROM category_performance
ORDER BY total_revenue DESC;
