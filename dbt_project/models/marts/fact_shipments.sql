WITH shipments AS (

    SELECT *
    FROM {{ ref('stg_shipments') }}

)

SELECT
    shipment_id,
    order_id,
    shipment_date,
    delivery_date,
    shipping_method,
    shipping_cost,
    shipment_status,
    (delivery_date - shipment_date) AS delivery_days

FROM shipments