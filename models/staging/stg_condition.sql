select
    condition_id, 
    person_id, 
    normalized_code_type, 
    normalized_code, 
    normalized_description,
    recorded_date, 
    onset_date, 
    status, 
    condition_type,
    {{ calculate_age('recorded_date') }} as age_at_diagnosis
from {{ source('tuva_input', 'condition') }}