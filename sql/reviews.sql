SELECT COUNT(*) AS no_of_reviews,
	COUNT(DISTINCT order_id) AS orders_with_review
FROM order_reviews;

SELECT delivery_status, 
	COUNT(*) AS orders,
	ROUND(AVG(avg_review_score), 2)  AS avg_score,
    ROUND( 100 * AVG(CASE WHEN avg_review_score <= 2 THEN 1 ELSE 0 END), 2)AS pct_low_reviews
FROM(
	SELECT ore.order_id,
		AVG(ore.review_score) AS avg_review_score,
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
			THEN 'Late' ELSE 'On_time'  END AS delivery_status
        FROM order_reviews ore
        JOIN orders o
			ON ore.order_id COLLATE utf8mb4_0900_ai_ci = o.order_id
		WHERE o.order_status = 'delivered'
			AND o.order_delivered_customer_date IS NOT NULL
            AND o.order_estimated_delivery_date IS NOT NULL
		GROUP BY ore.order_id, delivery_status) AS order_score
        GROUP BY delivery_status;
        
-- Order review table uses a utf8mb4 collation (to hold emojis). Collate in join resolved this