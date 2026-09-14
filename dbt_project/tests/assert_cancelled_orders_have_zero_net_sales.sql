select
    order_id,
    net_sales,
    is_cancelled
from {{ ref('fact_orders') }}
where is_cancelled = 1
  and net_sales > 0