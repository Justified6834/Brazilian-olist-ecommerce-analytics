SELECT DATE_FORMAT(o.order_purchase_timestamp,  '%Y-%m') AS month,
		COUNT(DISTINCT o.order_id) AS orders,
		ROUND(SUM(ot.price), 2) AS product_value
FROM orders o
INNER JOIN order_items ot
	ON o.order_id = ot.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

SELECT DATE_FORMAT(o.order_purchase_timestamp, '%m-%d') AS nov_day,
		COUNT(DISTINCT o.order_id) AS orders,
        ROUND(SUM(ot.price), 2) AS product_value
FROM orders o
INNER JOIN order_items ot
	ON o.order_id = ot.order_id
WHERE o.order_purchase_timestamp >= '2017-11-01'
	AND o.order_purchase_timestamp < '2017-12-01'
	AND o.order_status = 'delivered'
GROUP BY nov_day
ORDER BY nov_day;