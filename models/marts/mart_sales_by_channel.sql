select
    f.order_month, c.channel_name, c.channel_type,
    count(distinct f.order_id)            as orders,
    sum(f.quantity)                       as units,
    {{ to_zar('sum(f.line_revenue_zar)') }} as revenue_zar
from {{ ref('fct_order_lines') }} f
join {{ ref('stg_channels') }} c on f.channel_id = c.channel_id
group by 1, 2, 3
