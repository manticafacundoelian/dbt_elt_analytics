WITH dates AS (

    SELECT
        unnest(
            generate_series(
                DATE '2024-01-01',
                DATE '2027-12-31',
                INTERVAL '1 day'
            )
        )::DATE AS date

)

SELECT
    date,
    EXTRACT(YEAR FROM date)::INTEGER AS year,
    EXTRACT(QUARTER FROM date)::INTEGER AS quarter,
    EXTRACT(MONTH FROM date)::INTEGER AS month,
    STRFTIME(date, '%B') AS month_name,
    EXTRACT(WEEK FROM date)::INTEGER AS week,
    EXTRACT(DAYOFWEEK FROM date)::INTEGER AS day_of_week
FROM dates