with m as (
    select order_month,
           count(distinct order_id)       as orders,
           count(distinct customer_email) as customers,
           sum(quantity)                  as units,
           sum(line_revenue_zar)          as revenue_zar
    from {{ ref('fct_order_lines') }}
    group by 1
)
select
    order_month, orders, customers, units,
    {{ to_zar('revenue_zar') }}                 as revenue_zar,
    {{ to_zar('revenue_zar / orders') }}        as avg_order_value_zar,
    {{ to_zar('100.0 * (revenue_zar - lag(revenue_zar) over (order by order_month)) / nullif(lag(revenue_zar) over (order by order_month), 0)') }} as revenue_mom_pct
from m
