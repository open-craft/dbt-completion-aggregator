select org, entity_id, actor_id, count(*) as num_rows
from {{ ref("fact_aggregated_completions") }}
group by org, entity_id, actor_id
having num_rows > 1
