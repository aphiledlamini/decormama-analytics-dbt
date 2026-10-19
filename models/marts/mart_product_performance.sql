with agg as (
    select product_id,
           count(distinct order_id) as orders,
           sum(quantity) as units,
           sum(line_revenue_zar) as revenue_zar
    from {{ ref('fct_order_lines') }}
    group by 1
)
select
    p.product_id, p.sku, p.product_name, p.product_type,
    coalesce(a.orders, 0) as orders,
    coalesce(a.units, 0)  as units,
    {{ to_zar('coalesce(a.revenue_zar, 0)') }} as revenue_zar,
    rank() over (order by coalesce(a.revenue_zar, 0) desc) as revenue_rank
from {{ ref('stg_products') }} p
left join agg a on p.product_id = a.product_id
