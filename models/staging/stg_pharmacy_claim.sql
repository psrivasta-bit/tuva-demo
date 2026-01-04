select
    pharmacy_claim_id, 
    person_id, 
    claim_id, 
    ndc_code, 
    ndc_description,
    cast(paid_amount as decimal(18,2)) as rx_paid_amount,
    days_supply, 
    quantity, 
    dispensing_date
from {{ source('tuva_input', 'pharmacy_claim') }}