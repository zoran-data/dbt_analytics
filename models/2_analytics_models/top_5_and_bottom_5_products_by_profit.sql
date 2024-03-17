WITH
main AS (
    SELECT
        name AS product_name,
        products.id AS products_id,
        ROUND(retail_price) AS retail_price,
        ROUND(cost) AS cost,
        SUM(sale_price - cost) AS profit
    FROM {{ ref('products') }} AS products
    INNER JOIN {{ ref('order_items') }} AS orders
        ON products.id = orders.product_id
    WHERE
        status = 'Complete'
    GROUP BY 1, 2, 3, 4
),

top_least AS (
    SELECT
        *,
        RANK() OVER (ORDER BY profit ASC) AS top_rank
    FROM main
),

top_most AS (
    SELECT
        *,
        RANK() OVER (ORDER BY profit DESC) AS top_rank
    FROM main
)

SELECT
    *,
    'least profit' AS rank_values
FROM top_least
UNION ALL
SELECT
    *,
    'most profit' AS rank_values
FROM top_most
ORDER BY top_rank ASC, rank_values DESC
LIMIT 10
