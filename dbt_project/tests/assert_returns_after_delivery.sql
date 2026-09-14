with returns_with_delivery as (

    select
        r.return_id,
        r.return_date,
        s.delivery_date
    from {{ ref('stg_returns') }} r
    inner join {{ ref('stg_order_items') }} oi
        on r.order_item_id = oi.order_item_id
    inner join {{ ref('stg_shipments') }} s
        on oi.order_id = s.order_id

)

select *
from returns_with_delivery
where delivery_date is null
   or return_date < delivery_date