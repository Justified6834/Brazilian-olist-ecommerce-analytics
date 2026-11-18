CREATE OR REPLACE VIEW vw_order_totals AS
SELECT order_id,
       ROUND(SUM(price), 2) AS product_value,
       ROUND(SUM(freight_value), 2) AS freight
FROM order_items
GROUP BY order_id;

CREATE OR REPLACE VIEW vw_order_reviews AS
SELECT order_id, 
		AVG(review_score) AS avg_review_score
FROM order_reviews
GROUP BY order_id;

-- vw_orders: one row per order (99,441). Scope: all statuses.
--   delivery_days and is_late are filled only for delivered orders with both dates (96,470).
CREATE OR REPLACE VIEW vw_orders AS
SELECT o.order_id,
		o.order_purchase_timestamp AS purchase_date,
		DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS purchase_month,
		o.order_status,
		c.customer_unique_id,
        c.customer_state,
        ot.product_value,
        ot.freight,
        CASE WHEN o.order_status = 'delivered'
			AND o.order_delivered_customer_date IS NOT NULL
            AND o.order_estimated_delivery_date IS NOT NULL
            THEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)
            END AS delivery_days,
		CASE WHEN o.order_status = 'delivered'
			AND o.order_delivered_customer_date IS NOT NULL
            AND o.order_estimated_delivery_date IS NOT NULL
            THEN CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END
            END AS is_late,
		orr.avg_review_score
FROM orders o
JOIN customers c
	ON c.customer_id = o.customer_id
LEFT JOIN vw_order_totals ot
	ON o.order_id = ot.order_id
LEFT JOIN vw_order_reviews orr
	ON o.order_id = orr.order_id COLLATE utf8mb4_0900_ai_ci;
    
CREATE OR REPLACE VIEW vw_order_items AS
SELECT oi.order_id,
		oi.order_item_id,
        oi.product_id,
		oi.seller_id,
        s.seller_state,
        COALESCE(pc.product_category_name_english, 
			CASE p.product_category_name
				WHEN 'pc_gamer' THEN 'gaming_pc' 
				WHEN 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'kitchen_food_preparation_appliances' END,
			NULLIF(p.product_category_name, ''),
			'unknown') AS category,
		oi.price,
        oi.freight_value
FROM order_items oi
LEFT JOIN products p
	ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pc
	ON p.product_category_name = pc.product_category_name
LEFT JOIN sellers s
	ON oi.seller_id = s.seller_id;

CREATE VIEW vw_order_payments AS
SELECT order_id,
		payment_type,
        payment_installments,
        payment_value
FROM order_payments;

-- Feeds: KPI cards, monthly trend, late-rate-by-month, delivery-by-state, review chart.
