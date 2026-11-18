SELECT payment_type,
		COUNT(*) AS no_of_records,
		COUNT(DISTINCT order_id) AS orders,
		ROUND(SUM(payment_value), 2) as total_amount,
        ROUND(100 * SUM(payment_value) / SUM(SUM(payment_value)) OVER(), 2) pct_total_amount
FROM order_payments
GROUP BY payment_type
ORDER BY total_amount DESC;