-- Staging: Shopify-style orders (EXAMPLE data)
select
    cast(order_id as integer)                        as order_id,
    order_name,
    cast(cast(created_at as timestamptz) as date)    as order_date,
    cast(channel_id as integer)                      as channel_id,
    lower(trim(financial_status))                    as financial_status,
    lower(trim(customer_email))                      as customer_email
from {{ ref('raw_orders') }}
