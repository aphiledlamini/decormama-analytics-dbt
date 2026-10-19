select
    cast(product_id as integer)                  as product_id,
    sku,
    trim(replace(product_name, 'EXAMPLE ', ''))  as product_name,
    lower(product_type)                          as product_type,
    {{ to_zar('unit_price_zar') }}               as list_price_zar
from {{ ref('raw_products') }}
