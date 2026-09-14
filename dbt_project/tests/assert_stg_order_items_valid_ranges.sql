select
    order_item_id,
    quantity,
    unit_price,
    replacement_cost,
    discount_pct
from {{ ref('stg_order_items') }}
where quantity <= 0
   or unit_price <= 0
   or replacement_cost <= 0
   or discount_pct < 0
   or discount_pct > 1