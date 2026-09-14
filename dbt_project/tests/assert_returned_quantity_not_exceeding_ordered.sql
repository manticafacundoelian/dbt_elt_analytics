select
    r.return_id,
    r.order_item_id,
    r.quantity as returned_quantity,
    oi.quantity as ordered_quantity
from {{ ref('stg_returns') }} r
inner join {{ ref('stg_order_items') }} oi
    on r.order_item_id = oi.order_item_id
where r.quantity > oi.quantity