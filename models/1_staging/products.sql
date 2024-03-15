
with 

source as (
    select * from {{ source('analytics', 'products') }}
),

renamed as (
    select
        id,
        cost,
        category,
        name,
        brand,
        retail_price,
        department,
        sku,
        distribution_center_id
    from source
)

select * from renamed    
