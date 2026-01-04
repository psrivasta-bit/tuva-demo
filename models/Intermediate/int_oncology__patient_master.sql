select 
    -- 1. Identity & Demographics
    coh.person_id,
    coh.primary_diagnosis,
    pat.age,
    pat.sex,
    pat.state,
    
    -- 2. Financial Metrics
    fin.medical_paid,
    fin.pharmacy_paid,
    fin.total_total_paid_amount,
    fin.medical_allowed - fin.medical_paid as contractual_savings_gap,
    
    -- 3. Operational Adherence (Outcomes)
    appt.attended_visits,
    appt.missed_visits,
    
    -- 4. Insurance Context
    elig.payer,
    elig.plan,
    
    -- 5. Clinical Intensity
    coh.procedure_count,
    coh.lab_count,
    coh.observation_count,
    
    -- 6. Derived Logic: Savings Opportunity Flag
    case 
        when appt.miss_rate > 0.3 and fin.total_total_paid_amount > 20000 
        then 'High Risk / Cost Reduction Opp'
        else 'Standard Management'
    end as opportunity_segment

from {{ ref('int_oncology__cohort_identification') }} coh
left join {{ ref('int_oncology__financial_pivot') }} fin on coh.person_id = fin.person_id
left join {{ ref('stg_patient') }} pat on coh.person_id = pat.person_id
left join {{ ref('stg_eligibility') }} elig on coh.person_id = elig.person_id
left join (
    -- Adherence logic subquery
    select 
        person_id,
        count(case when normalized_status = 'fulfilled' then 1 end) as attended_visits,
        count(case when normalized_status in ('noshow', 'cancelled') then 1 end) as missed_visits,
        count(case when normalized_status in ('noshow', 'cancelled') then 1 end) * 1.0 / nullif(count(*), 0) as miss_rate
    from {{ ref('stg_appointment') }}
    group by 1
) appt on coh.person_id = appt.person_id