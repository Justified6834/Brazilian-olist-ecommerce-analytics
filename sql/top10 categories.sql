ALTER TABLE product_category_name_translation
RENAME COLUMN ï»¿product_category_name TO product_category_name;

SELECT COUNT(*)
FROM order_items ot
LEFT JOIN products p
	ON ot.product_id = p.product_id
LEFT JOIN product_category_name_translation pc
	ON p.product_category_name = pc.product_category_name;
    
SELECT COALESCE(pc.product_category_name_english,
	CASE p.product_category_name
    WHEN 'pc_gamer' THEN 'gaming_pc'
    WHEN 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'kitchen_food_preparation_appliances'
    END,
    -- two untranslated categories were manually mapped
    p.product_category_name, 'unknown') AS category,
    COUNT(ot.order_id) AS items_sold,
    COUNT(DISTINCT ot.order_id) AS orders,
    ROUND(SUM(ot.price), 2) AS product_value,
    ROUND(100 * SUM(ot.price) / SUM(SUM(ot.price))  OVER(), 2) AS pct_of_total,
	ROUND(100 * SUM(SUM(ot.price)) OVER(ORDER BY SUM(ot.price) DESC) / SUM(SUM(ot.price)) OVER(), 2) AS runinnig_total_pct
FROM order_items ot
LEFT JOIN products p
	ON ot.product_id = p.product_id
LEFT JOIN product_category_name_translation pc
	ON p.product_category_name = pc.product_category_name
GROUP BY category
ORDER BY product_value DESC
LIMIT 10;