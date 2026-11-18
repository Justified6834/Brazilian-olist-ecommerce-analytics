WITH 
	customer_count AS(
	SELECT customer_unique_id,
		COUNT(DISTINCT o.order_id) AS order_count
	FROM customers c
    JOIN orders o
		ON c.customer_id = o.customer_id
	GROUP BY customer_unique_id
)
SELECT COUNT(*) AS customers,
		SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
        ROUND(100 * AVG(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END), 2) AS pct_repeat_customers
FROM customer_count;

-- Customer_unique_id is used as the identifier because customer_id changes with each order