select 
    observation_id, 
    person_id, 
    encounter_id, 
    normalized_description as obs_name, 
    result as obs_value, 
    observation_date
from {{ source('tuva_input', 'observation') }}