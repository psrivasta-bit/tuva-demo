select 
    procedure_id, 
    person_id, 
    encounter_id, 
    normalized_description as proc_name, 
    cast(procedure_date as date) as procedure_date, 
    source_code
from {{ source('tuva_input', 'procedure') }}