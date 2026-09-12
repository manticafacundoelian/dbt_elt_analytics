WITH source AS (

    SELECT *
    FROM {{ ref('orders') }}

),

cleaned AS (

    SELECT
        order_id,
        customer_id,
        CAST(order_date AS DATE) AS order_date,
        LOWER(TRIM(channel)) AS channel,
        LOWER(TRIM(status)) AS order_status

    FROM source

)

SELECT *
FROM cleaned