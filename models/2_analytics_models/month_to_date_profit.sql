WITH
total_profit AS (
    SELECT
        DATE(orders.shipped_at) AS order_date,
        products.category AS product_categories,
        SUM(sale_price - cost) AS profit
    FROM {{ ref('products') }} AS products
    INNER JOIN {{ ref('order_items') }} AS orders
        ON products.id = orders.product_id
    WHERE
        status = 'Complete'
        AND orders.created_at BETWEEN '2022-06-01' AND '2022-08-15'
    GROUP BY 1, 2
    ORDER BY 2, 1
),

mtd_table AS (
    SELECT
        order_date,
        product_categories,
        profit,
        SUM(profit)
            OVER (
                PARTITION BY product_categories, EXTRACT(MONTH FROM order_date)
                ORDER BY 2, 1
            )
            AS mtd
    FROM total_profit
    ORDER BY 2, 1
)

SELECT
    order_date,
    product_categories,
    ROUND(mtd, 3) AS mtd
FROM mtd_table
WHERE
    order_date BETWEEN '2022-06-01' AND '2022-08-15'
    AND EXTRACT(DAY FROM order_date) = 15
