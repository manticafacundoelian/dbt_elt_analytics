select
    return_id,
    quantity,
    refund_amount,
    return_status
from {{ ref('stg_returns') }}
where quantity <= 0
   or refund_amount < 0
   or (return_status = 'rejected' and refund_amount <> 0)