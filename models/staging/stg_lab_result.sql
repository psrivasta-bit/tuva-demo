select 
    lab_result_id, 
    person_id, 
    encounter_id, 
    normalized_description as lab_name, 
    result as lab_value, 
    normalized_abnormal_flag, 
    collection_datetime
from {{ source('tuva_input', 'lab_result') }}