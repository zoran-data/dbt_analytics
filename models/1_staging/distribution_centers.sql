
with 

source as (
    select * from {{ source('analytics', 'distribution_centers') }}
),

renamed as (
    select
        id,
        name,
        latitude,
        longitude
    from source
)

select * from renamed    
