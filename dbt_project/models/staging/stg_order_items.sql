WITH source AS (

    SELECT *
    FROM {{ ref('order_items') }}

),

cleaned AS (

    SELECT
        order_item_id,
        order_id,
        product_id,
        CAST(quantity AS INTEGER) AS quantity,
        CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
        CAST(discount_pct AS DECIMAL(5,4)) AS discount_pct,
        CAST(replacement_cost AS DECIMAL(12,2)) AS replacement_cost
    
    FROM source

)

SELECT *
FROM cleaned