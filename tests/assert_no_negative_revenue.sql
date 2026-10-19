select * from {{ ref('fct_order_lines') }} where line_revenue_zar < 0 or quantity <= 0
