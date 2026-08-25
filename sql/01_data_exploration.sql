-- =====================================================
-- DATA EXPLORATION
-- Project: Sales Performance Analysis
-- Dataset: Olist
-- =====================================================

-- Count the number of rows in each table

SELECT 'customers', COUNT(*)
FROM `sales-analysis-olist.olist.customers`

UNION ALL

SELECT 'orders', COUNT(*)
FROM `sales-analysis-olist.olist.orders`

UNION ALL

SELECT 'order_items', COUNT(*)
FROM `sales-analysis-olist.olist.order_items`

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM `sales-analysis-olist.olist.order_payments`

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM `sales-analysis-olist.olist.order_reviews`

UNION ALL

SELECT 'products', COUNT(*)
FROM `sales-analysis-olist.olist.products`

UNION ALL

SELECT 'sellers', COUNT(*)
FROM `sales-analysis-olist.olist.sellers`

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM `sales-analysis-olist.olist.geolocation`

UNION ALL

SELECT 'category_translation', COUNT(*)
FROM `sales-analysis-olist.olist.category_translation`;


-- Dataset timespan

SELECT
    MIN(DATE(order_purchase_timestamp)) AS start_date,
    MAX(DATE(order_purchase_timestamp)) AS end_date
FROM `sales-analysis-olist.olist.orders`;



