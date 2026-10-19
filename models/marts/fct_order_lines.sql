-- Grain: one row per order line, paid orders only
select
    l.line_id, o.order_id, o.order_date,
    cast(date_trunc('month', o.order_date) as date) as order_month,
    o.channel_id, l.product_id, o.customer_email,
    l.quantity, l.line_revenue_zar,
    {{ to_zar('l.line_revenue_zar / (1 + ' ~ var('vat_rate') ~ ')') }} as line_revenue_excl_vat_zar
from {{ ref('stg_order_lines') }} l
join {{ ref('stg_orders') }} o on l.order_id = o.order_id
where o.financial_status = 'paid'
