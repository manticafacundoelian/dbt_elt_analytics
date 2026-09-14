with shipments as (

    select
        s.shipment_id,
        s.order_id,
        o.order_date,
        s.shipment_date,
        s.delivery_date,
        s.shipping_cost
    from {{ ref('stg_shipments') }} s
    inner join {{ ref('stg_orders') }} o
        on s.order_id = o.order_id

)

select *
from shipments
where shipping_cost <= 0
   or shipment_date < order_date
   or (delivery_date is not null and delivery_date < shipment_date)