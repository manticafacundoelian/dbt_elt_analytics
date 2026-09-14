select
    p.order_id,
    p.amount as payment_amount,
    o.net_sales as expected_net_sales
from {{ ref('fact_payments') }} p
inner join {{ ref('fact_orders') }} o
    on p.order_id = o.order_id
where p.payment_status = 'approved'
  and abs(p.amount - o.net_sales) > 0.01