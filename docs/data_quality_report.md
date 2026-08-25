# Data Quality Assessment

## Missing Values

- Checked critical columns in the **Orders** and **Products** tables.
- No missing values were found in `order_id`, `customer_id`, `order_status`, or `order_purchase_timestamp`.
- `product_category_name` contains **610** missing values.
- Missing product categories will be handled during analysis using `COALESCE(product_category_name, 'Unknown')` without modifying the raw dataset.

## Duplicate Records

- Verified primary keys in **Customers**, **Orders**, **Products**, and **Sellers**.
- No duplicate primary keys were found.

## Invalid Values

- No negative product prices were detected.
- No negative freight values were detected.

## Conclusion

The dataset was assessed for basic data quality issues and is suitable for sales performance analysis. No significant issues requiring data cleaning were identified. The only notable issue was missing product categories, which will be handled during analysis while preserving the original dataset.