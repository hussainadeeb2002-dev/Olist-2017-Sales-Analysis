/*
===========================================
Data Quality Assessment
Project: Sales Performance Analysis
Dataset: Olist E-commerce Dataset

Objective:
Assess the quality of the dataset before
performing analysis.

Checks:
1. Missing Values
2. Duplicate Records
3. Invalid Values
-- =====================================================
*/


-- Check missing values in important columns of orders table

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(order_id IS NULL) AS order_id_nulls,
    COUNTIF(customer_id IS NULL) AS customer_id_nulls,
    COUNTIF(order_status IS NULL) AS order_status_nulls,
    COUNTIF(order_purchase_timestamp IS NULL) AS purchase_timestamp_nulls
FROM `sales-analysis-olist.olist.orders`;

-- Check missing values in important columns of products table

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(product_id IS NULL) AS product_id_nulls,
    COUNTIF(product_category_name IS NULL) AS category_nulls
FROM `sales-analysis-olist.olist.products`;

-- Check for duplicate order IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM `sales-analysis-olist.olist.orders`;

-- Check duplicate customer IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM `sales-analysis-olist.olist.customers`;

-- Check duplicate product IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM `sales-analysis-olist.olist.products`;

-- Check duplicate seller IDs

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM `sales-analysis-olist.olist.sellers`;

-- Check for negative prices

SELECT *
FROM `sales-analysis-olist.olist.order_items`
WHERE price < 0;

-- Check for negative freight values

SELECT *
FROM `sales-analysis-olist.olist.order_items`
WHERE freight_value < 0;