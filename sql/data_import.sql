CREATE DATABASE olist_analytics;
USE olist_analytics;
SELECT DATABASE();

SELECT COUNT(*) AS total_customers
FROM customers;
SELECT COUNT(*) AS total_order_items
FROM order_items;
SELECT COUNT(*) 
FROM product_category_name_translation;

CrEATE TABLE order_reviews(
review_id VARCHAR (32) NOT NULL,
order_id VARCHAR (32) NOT NULL,
review_score INT NOT NULL,
review_comment_title VARCHAR (255)  NULL,
review_comment_message TEXT NULL,
review_creation_date DATETIME NOT NULL,
review_answer_timestamp DATETIME NOT NULL,
PRIMARY KEY (review_id, order_id)
)
DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
LOAD DATA LOCAL INFILE 'path/to/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(review_id, order_id, review_score, @title, @message, review_creation_date, review_answer_timestamp)
SET review_comment_title = NULLIF(@title, ''),
    review_comment_message = NULLIF(@message, '');
SELECT COUNT(*) FROM order_reviews;
-- order_reviews table was created and imported with collate to take care of the character set
SELECT 'customers' AS table_name,
COUNT(*) AS row_count
FROM customers
UNION ALL

SELECT 'order_items',
COUNT(*)
FROM order_items
UNION ALL

SELECT 'order_payments',
COUNT(*)
FROM order_payments
UNION ALL

SELECT 'order_reviews',
COUNT(*)
FROM order_reviews
UNION ALL

SELECT 'orders',
COUNT(*)
FROM orders
UNION ALL

SELECT 'product_category_name_translation',
COUNT(*)
FROM product_category_name_translation
UNION ALL

SELECT 'products',
COUNT(*)
FROM products
UNION ALL

SELECT 'sellers',
COUNT(*)
FROM sellers;