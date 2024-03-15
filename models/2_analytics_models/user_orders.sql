-- file: models/user_orders.sql

WITH UserOrders AS (
    SELECT
        u.id AS user_id,
        u.first_name,
        u.last_name,
        o.order_id,
        o.status,
        o.created_at AS order_created_at,
        o.returned_at,
        o.shipped_at,
        o.delivered_at,
        oi.product_id,
        ini.product_name,       
        oi.sale_price
    FROM {{ ref('users') }} AS u
    INNER JOIN {{ ref('orders') }} AS o ON u.id = o.user_id
    INNER JOIN {{ ref('order_items') }} AS oi ON o.order_id = oi.order_id
    INNER JOIN {{ ref('inventory_items') }} AS ini ON oi.product_id = ini.product_id
)

SELECT
    user_id,
    first_name,
    last_name,
    AVG(sale_price) AS avg_order_value
FROM UserOrders
GROUP BY user_id, first_name, last_name
