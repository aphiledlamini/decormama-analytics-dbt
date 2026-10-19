-- Revenue in the channel mart must equal revenue in the fact table
select 1
from (select sum(revenue_zar) r from {{ ref('mart_sales_by_channel') }}) a,
     (select sum(line_revenue_zar) r from {{ ref('fct_order_lines') }}) b
where abs(a.r - b.r) > 0.01
