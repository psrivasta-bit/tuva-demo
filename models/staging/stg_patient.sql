select
    person_id, 
    sex, 
    race, 
    birth_date, 
    death_date, 
    death_flag,
    age, 
    age_group, 
    address, 
    city, 
    state, 
    zip_code
from {{ source('tuva_input', 'patient') }}