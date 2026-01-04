select 
    person_id, member_id, subscriber_id, payer, plan, 
    cast(enrollment_start_date as date) as start_date, 
    cast(enrollment_end_date as date) as end_date
from {{ source('tuva_input', 'eligibility') }}