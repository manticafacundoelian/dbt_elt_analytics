WITH source AS (

    SELECT *
    FROM {{ ref('products') }}

),

cleaned AS (

    SELECT
        product_id,
        TRIM(product_name) AS product_name,
        TRIM(category) AS category,
        TRIM(brand) AS brand,
        CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
        CAST(unit_cost AS DECIMAL(12,2)) AS unit_cost,
        LOWER(TRIM(status)) AS product_status,
        CAST(created_at AS DATE) AS created_at

    FROM source

)

SELECT *
FROM cleaned