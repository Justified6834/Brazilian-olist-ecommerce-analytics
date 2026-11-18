WITH order_totals AS(
	SELECT order_id,
		ROUND(SUM(price), 2) AS product_value,
        ROUND(SUM(freight_value), 2) AS freight
	FROM order_items
    GROUP BY order_id
)
SELECT c.customer_state,
		COUNT(ot.order_id) AS orders,
        ROUND(SUM(ot.product_value), 2) AS product_value,
        ROUND(SUM(ot.freight), 2) AS freight_value,
        ROUND(100 * SUM(ot.product_value) / SUM(SUM(ot.product_value)) OVER(), 2) AS pct_of_total_product_value,
		ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
        ROUND(100 * AVG(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END), 2) AS late_delivery_rate
FROM order_totals ot
JOIN orders o
	ON ot.order_id = o. order_id
JOIN customers c
	ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
	AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY product_value DESC;