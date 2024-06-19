{% test is_completed(model, progress_field) %}

with validation as (

    select
        completion,
        {{ progress_field }} as progress,

    from {{ model }}

),

validation_errors as (

    select
        completion, scaled_progress

    from validation
    -- if this is true, then progress isn't being captured correctly
    where completion == true and progress < 100

)

select *
from validation_errors

{% endtest %}
