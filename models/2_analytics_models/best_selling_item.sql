SELECT
    oi.product_id AS product_id,
    p.name AS product_name,
    p.category AS product_category,
    count(*) AS num_of_orders
FROM {{ ref('products') }} AS p
INNER JOIN {{ ref('order_items') }} AS oi
    ON p.id = oi.product_id
GROUP BY 1, 2, 3
ORDER BY num_of_orders DESC
