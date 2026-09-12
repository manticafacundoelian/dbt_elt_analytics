SELECT
    product_id,
    product_name,
    category,
    brand,
    unit_price,
    unit_cost,
    product_status,
    created_at
FROM {{ ref('stg_products') }}