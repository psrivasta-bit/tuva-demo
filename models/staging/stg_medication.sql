select 
      medication_id,
      person_id, 
      ndc_code, 
      ndc_description, 
      rxnorm_code, 
      rxnorm_description, 
      status
from {{ source('tuva_input', 'medication') }}