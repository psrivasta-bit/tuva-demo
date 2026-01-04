select 
    person_id, 
    patient_id, 
    member_id
from {{ source('tuva_input', 'person_id_crosswalk') }}