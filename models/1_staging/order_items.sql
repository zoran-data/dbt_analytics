
with 

source as (
    select * from {{ source('analytics', 'order_items') }}
),

renamed as (
    select
        id,
        order_id,
        user_id,
        product_id,
        inventory_item_id,
        status,
        created_at,
        shipped_at,
        delivered_at,
        returned_at,
        sale_price        
    from source
)

select * from renamed    
