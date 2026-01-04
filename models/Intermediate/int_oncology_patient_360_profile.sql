with cancer_cohort as (
    select distinct person_id, diagnosis_desc as cancer_type
    from {{ ref('stg_condition') }}
    where icd_10_code ilike 'C%'
),

-- Aggregate Medical Spend by Care Setting
medical_spend_detail as (
    select 
        person_id,
        sum(case when care_setting = 'Inpatient' then paid_amount else 0 end) as inpatient_spend,
        sum(case when care_setting = 'Emergency Department' then paid_amount else 0 end) as er_spend,
        sum(case when care_setting = 'Outpatient' then paid_amount else 0 end) as outpatient_spend,
        sum(paid_amount) as total_med_paid,
        sum(allowed_amount) as total_med_allowed
    from {{ ref('stg_medical_claim') }}
    group by 1
),

-- Identify Clinical Instability (Abnormal Labs & Observations)
clinical_severity as (
    select 
        person_id,
        count(case when normalized_abnormal_flag = 'abnormal' then 1 end) as abnormal_lab_count,
        count(distinct procedure_id) as total_procedures
    from (
        select person_id, lab_result_id, normalized_abnormal_flag, null as procedure_id from {{ ref('stg_lab_result') }}
        union all
        select person_id, null, null, procedure_id from {{ ref('stg_procedure') }}
    )
    group by 1
),

-- Operational Adherence
care_engagement as (
    select 
        person_id,
        count(case when status = 'fulfilled' then 1 end) as completed_visits,
        count(case when status in ('noshow', 'cancelled') then 1 end) as missed_visits
    from {{ ref('stg_appointment') }}
    group by 1
)

select 
    c.person_id,
    c.cancer_type,
    p.age_group,
    p.state,
    -- Financials
    m.inpatient_spend, m.er_spend, m.outpatient_spend, m.total_med_paid,
    coalesce(rx.rx_paid, 0) as total_rx_paid,
    -- Outcomes & Severity
    coalesce(s.abnormal_lab_count, 0) as abnormal_lab_count,
    coalesce(s.total_procedures, 0) as total_procedures,
    coalesce(e.completed_visits, 0) as completed_visits,
    coalesce(e.missed_visits, 0) as missed_visits,
    -- Complex Logic: Risk Stratification
    case 
        when m.er_spend > 0 and e.missed_visits > 1 then 'High Risk: Engagement Failure'
        when m.inpatient_spend > 20000 then 'High Risk: Acute Severity'
        else 'Standard Management'
    end as clinical_risk_segment
from cancer_cohort c
left join {{ ref('stg_patient') }} p on c.person_id = p.person_id
left join medical_spend_detail m on c.person_id = m.person_id
left join {{ ref('stg_pharmacy_claim') }} rx on c.person_id = rx.person_id
left join clinical_severity s on c.person_id = s.person_id
left join care_engagement e on c.person_id = e.person_id