select
    cast(line_id as integer)     as line_id,
    cast(order_id as integer)    as order_id,
    cast(product_id as integer)  as product_id,
    cast(quantity as integer)    as quantity,
    {{ to_zar('price_zar') }}    as unit_price_zar,
    {{ to_zar('quantity * price_zar') }} as line_revenue_zar
from {{ ref('raw_order_lines') }}
