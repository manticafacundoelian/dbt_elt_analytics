WITH items AS (

    SELECT * FROM {{ ref('int_order_items_enriched') }}

),

shipment_info AS (

    SELECT
        order_id,
        MAX(shipping_method) AS shipping_method
    FROM {{ ref('stg_shipments') }}
    GROUP BY order_id

),

order_level AS (

    SELECT
        i.order_id,
        MAX(i.customer_id) AS customer_id,
        MAX(i.order_date) AS order_date,
        MAX(i.channel) AS channel,
        MAX(i.order_status) AS order_status,
        MAX(i.is_cancelled) AS is_cancelled,
        MAX(i.is_resolved) AS is_resolved,

        COUNT(DISTINCT i.product_id) AS distinct_products,
        SUM(i.quantity) AS total_units,

        SUM(i.gross_amount) AS gross_amount,
        SUM(i.discount_amount) AS discount_amount,
        SUM(i.net_sales) AS net_sales,

        SUM(i.refund_amount) AS refund_amount,
        SUM(i.returned_units) AS returned_units,
        SUM(i.final_net_sales) AS final_net_sales,
        SUM(i.final_item_cogs) AS final_cogs,
        SUM(i.allocated_shipping_cost) AS shipping_cost,

        SUM(i.net_profit) AS net_profit

    FROM items AS i
    GROUP BY i.order_id

)

SELECT
    ol.*,
    si.shipping_method
FROM order_level AS ol
LEFT JOIN shipment_info AS si
    ON ol.order_id = si.order_id

