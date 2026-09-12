WITH source AS (

    SELECT *
    FROM {{ ref('shipments') }}

),

cleaned AS (

    SELECT
        shipment_id,
        order_id,
        CAST(shipment_date AS DATE) AS shipment_date,
        CAST(delivery_date AS DATE) AS delivery_date,
        LOWER(TRIM(shipping_method)) AS shipping_method,
        CAST(shipping_cost AS DECIMAL(12,2)) AS shipping_cost,
        LOWER(TRIM(status)) AS shipment_status

    FROM source

)

SELECT *
FROM cleaned