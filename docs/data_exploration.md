-- Determine the number of records available in each table to understand the size and structure of the dataset.

### Result

| Table | Number of Records |
|--------|------------------:|
| customers | 99,441 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |
| products | 32,951 |
| sellers | 3,095 |
| geolocation | 1,000,163 |
| category_translation | 71 |

### Findings

- The dataset contains **99,441 customer records** and an equal number of **orders**, indicating one record per order in the `orders` table.
- The `order_items` table contains **112,650 records**, which is greater than the total number of orders, indicating that some orders contain multiple items.
- The `order_payments` table contains **103,886 payment records**, suggesting that some orders were completed using multiple payment transactions.
- The `order_reviews` table contains **99,224 reviews**, indicating that not every order has an associated customer review.
- The marketplace includes **32,951 products** offered by **3,095 sellers**.
- The `geolocation` table is the largest table in the dataset, containing **1,000,163 records** of geographic information.
- The `category_translation` table contains **71 product category translations**, which are used to map Portuguese category names to English. 

-- What is the time span of the dataset?

### Result

| Start Date | End Date |
|------------|----------|
| 2016-09-04 | 2018-10-17 |

### Key Findings

- The dataset contains order records from **September 4, 2016** to **October 17, 2018**.
- The analysis covers only for the year 2017 of customer purchase activity.
- All subsequent sales and business analyses are based on transactions within this time period.


