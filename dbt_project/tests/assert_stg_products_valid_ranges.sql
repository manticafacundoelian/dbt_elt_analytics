select
    product_id,
    unit_price,
    unit_cost
from {{ ref('stg_products') }}
where unit_price <= 0
   or unit_cost <= 0