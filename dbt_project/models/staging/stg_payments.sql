WITH source AS (

    SELECT *
    FROM {{ ref('payments') }}

),

cleaned AS (

    SELECT
        payment_id,
        order_id,
        CAST(payment_date AS DATE) AS payment_date,
        LOWER(TRIM(payment_method)) AS payment_method,
        CAST(amount AS DECIMAL(12,2)) AS amount,
        LOWER(TRIM(status)) AS payment_status

    FROM source

)

SELECT *
FROM cleaned