with cancer_diagnoses as (
    -- Filters for ICD-10 Malignant Neoplasm codes
    select 
        person_id,
        normalized_description as primary_diagnosis,
        min(recorded_date) as original_diagnosis_date,
        count(distinct condition_id) as total_condition_occurrences
    from {{ ref('stg_condition') }}
    where normalized_code ilike 'C%'
    group by 1, 2
),

clinical_activity as (
    -- Aggregates Labs, Procedures, and Observations
    select 
        person_id,
        count(distinct procedure_id) as procedure_count,
        count(distinct lab_result_id) as lab_count,
        count(distinct observation_id) as observation_count
    from (
        select person_id, 
               procedure_id, 
               null as lab_result_id, 
               null as observation_id 
        from {{ ref('stg_procedure') }}
        union all
        select person_id, 
               null, 
               lab_result_id, 
               null 
        from {{ ref('stg_lab_result') }}
        union all
        select person_id, 
               null, 
               null, 
               observation_id 
        from {{ ref('stg_observation') }}
    )
    group by 1
)

select 
    cd.*,
    coalesce(ca.procedure_count, 0) as procedure_count,
    coalesce(ca.lab_count, 0) as lab_count,
    coalesce(ca.observation_count, 0) as observation_count
from cancer_diagnoses cd
left join clinical_activity ca on cd.person_id = ca.person_id