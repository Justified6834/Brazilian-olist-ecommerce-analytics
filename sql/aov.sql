SELECT ROUND(SUM(price), 2) AS product_value,
		ROUND(SUM(freight_value), 2) AS freight_value,
        COUNT(DISTINCT order_id) AS order_count,
        ROUND(SUM(freight_value + price), 2) AS order_value,
        ROUND(SUM(freight_value + price) / COUNT(DISTINCT order_id), 2) AS aov,
        ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) aov_product_only
FROM order_items;