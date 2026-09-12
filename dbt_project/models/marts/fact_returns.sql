WITH returns AS (

    SELECT * FROM {{ ref('stg_returns') }}

),

order_items AS (

    SELECT 
        order_item_id, 
        order_id, 
        customer_id, 
        product_id 
    FROM {{ ref('int_order_items_enriched') }}

)

SELECT
    r.return_id,
    r.order_item_id,
    i.order_id,
    i.customer_id,
    i.product_id,
    r.return_date,
    r.quantity,
    r.reason,
    r.refund_amount,
    r.return_status
FROM returns r
LEFT JOIN order_items i ON r.order_item_id = i.order_item_id