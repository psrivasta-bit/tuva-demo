
select
    appointment_id, 
    person_id, 
    encounter_id,
    start_datetime, 
    end_datetime, 
    duration,
    normalized_status, 
    normalized_appointment_type_description,
    appointment_specialty, 
    normalized_reason_description
from {{ source('tuva_input', 'appointment') }}