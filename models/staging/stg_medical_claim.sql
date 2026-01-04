select
    medical_claim_id, 
    claim_id, 
    person_id, 
    member_id, 
    cast(claim_start_date as date) as claim_start_date,
    cast(claim_end_date as date) as claim_end_date,
    service_category_1, 
    service_category_2, 
    service_category_3,
    encounter_type, 
    place_of_service_description, 
    bill_type_description,
    cast(paid_amount as decimal(18,2)) as paid_amount,
    cast(allowed_amount as decimal(18,2)) as allowed_amount,
    cast(charge_amount as decimal(18,2)) as charge_amount,
    cast(total_cost_amount as decimal(18,2)) as total_cost_amount,
    {{ get_care_setting('service_category_1') }} as care_setting_group,
    {{ classify_spend('paid_amount') }} as spend_segment_label
    data_source
from {{ source('tuva_input', 'medical_claim') }}