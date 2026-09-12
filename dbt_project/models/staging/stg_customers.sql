WITH source AS (

    SELECT *
    FROM {{ ref('customers') }}

),

cleaned AS (

    SELECT
        customer_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        LOWER(TRIM(email)) AS email,
        CAST(registration_date AS DATE) AS registration_date,
        LOWER(TRIM(province)) AS province,
        LOWER(TRIM(status)) AS customer_status

    FROM source

)

SELECT *
FROM cleaned