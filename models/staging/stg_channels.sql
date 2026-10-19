select cast(channel_id as integer) as channel_id, channel_name, channel_type
from {{ ref('raw_channels') }}
