SELECT
    customer_id,
    first_name,
    last_name,
    email,
    registration_date,
    province,
    customer_status
FROM {{ ref('stg_customers') }}