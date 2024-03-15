SELECT
    u.id AS user_id,
    u.first_name,
    u.last_name,
    avg(oi.sale_price) AS avg_sale_price
FROM {{ ref('users') }}  AS u
INNER JOIN {{ ref('order_items') }} AS oi
    ON u.id = oi.user_id
GROUP BY 1, 2, 3
ORDER BY avg_sale_price DESC
