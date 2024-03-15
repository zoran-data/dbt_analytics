WITH 
    UserCTE AS (
        SELECT 
            id AS user_id,
            age,
            gender,
            city,
            traffic_source,
            latitude,
            longitude
        FROM {{ ref('users') }}
        WHERE country = 'United States'
        AND EXTRACT(YEAR FROM created_at) >= EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
    ),
    OrderItemCTE AS (
        SELECT
            order_id,
            status,
            product_id,
            user_id,
            inventory_item_id,
            created_at,
            shipped_at,
            delivered_at
        FROM {{ ref('order_items') }}
        WHERE status = 'Returned' OR status = 'Complete'
    ),
    InventoryItemCTE AS (
        SELECT
            id AS inventory_item_id,
            product_category,
            product_name,
            product_retail_price,
            product_distribution_center_id
        FROM {{ ref('inventory_items') }}
    ),
    DistributionCenterCTE AS (
        SELECT
            id AS dc_id,
            name AS dc_name,
            latitude AS dc_latitude,
            longitude AS dc_longitude
        FROM {{ ref('distribution_centers') }}
    )
SELECT
    u.user_id,
    u.age,
    u.gender,
    u.city,
    u.traffic_source,
    oi.order_id,
    oi.status,
    oi.product_id,
    ini.product_category,
    ini.product_name,
    ini.product_retail_price,
    dc.dc_name,
    dc.dc_latitude AS d_lat,
    dc.dc_longitude AS d_long,
    u.latitude AS u_lat,
    u.longitude AS u_long,
    oi.created_at,
    oi.shipped_at,
    oi.delivered_at,    
    TIMESTAMP_DIFF(oi.shipped_at, oi.created_at, MINUTE) AS prep_time,
    TIMESTAMP_DIFF(oi.delivered_at, oi.shipped_at, MINUTE) AS delivery_time,
    TIMESTAMP_DIFF(oi.shipped_at, oi.created_at, MINUTE) + TIMESTAMP_DIFF(oi.delivered_at, oi.shipped_at, MINUTE) AS total_time
FROM 
    UserCTE AS u
INNER JOIN 
    OrderItemCTE AS oi ON u.user_id = oi.user_id
INNER JOIN 
    InventoryItemCTE AS ini ON oi.inventory_item_id = ini.inventory_item_id
LEFT JOIN 
    DistributionCenterCTE AS dc ON ini.product_distribution_center_id = dc.dc_id