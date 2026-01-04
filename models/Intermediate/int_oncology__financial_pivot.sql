with med_claims as (
    select 
        person_id,
        sum(paid_amount) as medical_paid,
        sum(allowed_amount) as medical_allowed,
        sum(charge_amount) as medical_charge,
        count(distinct claim_id) as claim_count
    from {{ ref('stg_medical_claim') }}
    group by 1
),

rx_claims as (
    select 
        person_id,
        sum(rx_paid_amount) as pharmacy_paid,
        count(distinct ndc_code) as unique_rx_count
    from {{ ref('stg_pharmacy_claim') }}
    group by 1
)

select 
    m.person_id,
    m.medical_paid,
    m.medical_allowed,
    m.medical_charge,
    coalesce(r.pharmacy_paid, 0) as pharmacy_paid,
    (m.medical_paid + coalesce(r.pharmacy_paid, 0)) as total_total_paid_amount,
    m.claim_count,
    coalesce(r.unique_rx_count, 0) as rx_count
from med_claims m
left join rx_claims r on m.person_id = r.person_id