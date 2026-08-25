
Fact Tables:

| Table          | Grain                           |
| -------------- | ------------------------------- |
| orders         | One row per order               |
| order_items    | One row per product in an order |
| order_payments | One row per payment transaction |
| order_reviews  | One review for an order         |

Dimension Tables:

| Table                | Describes                    |
| -------------------- | ---------------------------- |
| customers            | Customer                     |
| products             | Product                      |
| sellers              | Seller                       |
| geolocation          | Postal code/location         |
| category_translation | Product category translation |

Primary Keys:

| Table                | Primary Key           |
| -------------------- | --------------------- |
| customers            | customer_id           |
| orders               | order_id              |
| products             | product_id            |
| sellers              | seller_id             |
| category_translation | product_category_name |

Composite Key:

| Table       | Key                      |
| ----------- | ------------------------ |
| order_items | order_id + order_item_id |

Foreign Keys:

| Child          | Foreign Key | Parent    |
| -------------- | ----------- | --------- |
| orders         | customer_id | customers |
| order_items    | order_id    | orders    |
| order_items    | product_id  | products  |
| order_items    | seller_id   | sellers   |
| order_payments | order_id    | orders    |
| order_reviews  | order_id    | orders    |
