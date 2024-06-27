{{
    config(
        materialized="materialized_view",
        schema=env_var("ASPECTS_XAPI_DATABASE", "xapi"),
        engine=aspects.get_engine("ReplacingMergeTree()"),
        primary_key="(org, course_key, verb_id)",
        order_by="(org, course_key, verb_id, emission_time, actor_id, object_id, event_id)",
        partition_by="(toYYYYMM(emission_time))",
        ttl=env_var("ASPECTS_DATA_TTL_EXPRESSION", ""),
    )
}}

select
    event_id,
    CAST(emission_time, 'DateTime') as emission_time,
    actor_id,
    object_id,
    course_key,
    org,
    verb_id,
    JSON_VALUE(
        event,
        '$.result.extensions."https://w3id.org/xapi/cmi5/result/extensions/progress"'
    ) as progress_percent,
    JSON_VALUE(
        event,
        '$.result.completion'
    ) as completed
from {{ ref("xapi_events_all_parsed") }}
where verb_id = 'http://adlnet.gov/expapi/verbs/progressed'
