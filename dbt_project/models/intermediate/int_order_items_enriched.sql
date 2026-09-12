WITH order_items AS (

    SELECT * FROM {{ ref('stg_order_items') }}

),

orders AS (

    SELECT * FROM {{ ref('stg_orders') }}

),

-- Reemplaza a int_order_totals: Solo nos interesa el total de unidades del pedido
order_unit_totals AS (

    SELECT 
        order_id, 
        SUM(quantity) AS total_units 
    FROM order_items 
    GROUP BY order_id

),

shipments AS (

    SELECT
        order_id,
        SUM(shipping_cost) AS shipping_cost
    FROM {{ ref('stg_shipments') }}
    GROUP BY order_id

),

returns AS (

    SELECT
        order_item_id,
        SUM(refund_amount) AS item_refund_amount,
        SUM(quantity) AS item_returned_units
    FROM {{ ref('stg_returns') }}
    WHERE return_status = 'approved'
    GROUP BY order_item_id

),

base AS (

    SELECT
        i.order_item_id,
        i.order_id,
        o.customer_id,
        i.product_id,
        o.order_date,
        o.channel,
        o.order_status,
        i.quantity,
        i.unit_price,
        i.replacement_cost,
        i.discount_pct,

        CASE WHEN o.order_status = 'cancelled' THEN 1 ELSE 0 END AS is_cancelled,
        CASE WHEN o.order_status IN ('delivered', 'cancelled') THEN 1 ELSE 0 END AS is_resolved,

        -- Brutos: se calculan siempre
        (i.quantity * i.unit_price) AS gross_amount,
        (i.quantity * i.unit_price * i.discount_pct) AS discount_amount,
        (i.quantity * i.unit_price * (1 - i.discount_pct)) AS gross_net_sales,

        COALESCE(r.item_refund_amount, 0.0) AS refund_amount,
        COALESCE(r.item_returned_units, 0) AS returned_units,

        GREATEST(
            (i.quantity * i.replacement_cost)
            - (COALESCE(r.item_returned_units, 0) * i.replacement_cost),
            0.0
        ) AS gross_item_cogs,

        -- Envío Prorrateado: Blindado al 100% contra divisiones por cero y NULLs
        COALESCE(
            ROUND(
                COALESCE(s.shipping_cost, 0.0)
                * (i.quantity::DECIMAL / NULLIF(orut.total_units, 0)),
                2
            ),
            0.0
        ) AS gross_allocated_shipping_cost

    FROM order_items AS i
    INNER JOIN orders AS o ON i.order_id = o.order_id
    LEFT JOIN order_unit_totals AS orut ON i.order_id = orut.order_id
    LEFT JOIN shipments AS s ON i.order_id = s.order_id
    LEFT JOIN returns AS r ON i.order_item_id = r.order_item_id

)

SELECT
    order_item_id,
    order_id,
    customer_id,
    product_id,
    order_date,
    channel,
    order_status,
    is_cancelled,
    is_resolved,
    quantity,
    unit_price,
    replacement_cost,
    discount_pct,

    gross_amount,
    discount_amount,

    CASE WHEN is_cancelled = 1 THEN 0.0 ELSE gross_net_sales END AS net_sales,

    refund_amount,
    returned_units,

    CASE
        WHEN is_cancelled = 1 THEN 0.0
        ELSE (gross_net_sales - refund_amount)
    END AS final_net_sales,

    CASE WHEN is_cancelled = 1 THEN 0.0 ELSE gross_item_cogs END AS final_item_cogs,

    CASE WHEN is_cancelled = 1 THEN 0.0 ELSE gross_allocated_shipping_cost END AS allocated_shipping_cost,

    CASE
        WHEN is_cancelled = 1 THEN 0.0
        ELSE (
            (gross_net_sales - refund_amount)
            - gross_item_cogs
            - gross_allocated_shipping_cost
        )
    END AS net_profit

FROM base

