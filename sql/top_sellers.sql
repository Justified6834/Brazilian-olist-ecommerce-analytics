SELECT ot.seller_id, s.seller_city, s.seller_state,
		COUNT(ot.order_id) AS items_sold,
        COUNT(DISTINCT ot.order_id) AS orders,
        ROUND(SUM(ot.price), 2) AS product_value,
        ROUND(100 * SUM(ot.price) / SUM(SUM(ot.price)) OVER(), 2) AS pct_of_total,
        ROUND( 100 * SUM(SUM(ot.price)) OVER (ORDER BY SUM(ot.price) DESC) / SUM(SUM(ot.price)) OVER(), 2) AS running_total_pct
FROM order_items ot
LEFT JOIN sellers s
ON ot.seller_id = s.seller_id
GROUP BY ot.seller_id, s.seller_city, s.seller_state
ORDER BY product_value DESC
LIMIT 10;