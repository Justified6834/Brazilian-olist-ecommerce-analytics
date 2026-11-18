DESCRIBE orders;
SET SQL_SAFE_UPDATES = 0;
UPDATE orders
SET 
    order_purchase_timestamp = IF(order_purchase_timestamp = '', NULL, order_purchase_timestamp),
    order_approved_at = IF(order_approved_at = '', NULL, order_approved_at),
    order_delivered_carrier_date = IF(order_delivered_carrier_date = '', NULL, order_delivered_carrier_date),
    order_delivered_customer_date = IF(order_delivered_customer_date = '', NULL, order_delivered_customer_date),
    order_estimated_delivery_date = IF(order_estimated_delivery_date = '', NULL, order_estimated_delivery_date);
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE orders
	MODIFY COLUMN order_purchase_timestamp DATETIME,
	MODIFY COLUMN order_approved_at DATETIME,
	MODIFY COLUMN order_delivered_carrier_date  DATETIME,
	MODIFY COLUMN order_delivered_customer_date DATETIME,
	MODIFY COLUMN order_estimated_delivery_date DATETIME;
SELECT COUNT(*) FROM orders WHERE order_delivered_customer_date IS NULL;

SELECT
	COUNT(*) AS orders_with_complete_dates,
	ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100 * AVG(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END), 2) AS late_delivery_pct
FROM orders
WHERE order_status = 'delivered'
	AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL;

SELECT
	DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS orders_with_complete_dates,
	ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100 * AVG(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END), 2) AS late_delivery_pct
FROM orders
WHERE order_status = 'delivered'
	AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
GROUP BY month
ORDER BY month;
-- avg_delivert_days are calendar dates