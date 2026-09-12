WITH source AS (

    SELECT *
    FROM {{ ref('returns') }}

),

cleaned AS (

    SELECT
        return_id,
        order_item_id,
        CAST(return_date AS DATE) AS return_date,
        CAST(quantity AS INTEGER) AS quantity,
        LOWER(TRIM(reason)) AS reason,
        CAST(refund_amount AS DECIMAL(12,2)) AS refund_amount,
        LOWER(TRIM(status)) AS return_status

    FROM source

)

SELECT *
FROM cleaned