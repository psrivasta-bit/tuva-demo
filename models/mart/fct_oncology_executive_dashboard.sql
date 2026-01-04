select
    -- 1. Analysis Dimensions
    primary_diagnosis,
    payer,
    plan,
    age_group,
    opportunity_segment,

    -- 2. Patient Volume Metrics
    count(distinct person_id) as total_patient_count,

    -- 3. Financial Analysis (Savings)
    sum(total_total_paid_amount) as total_spend,
    sum(medical_paid) as total_medical_spend,
    sum(pharmacy_paid) as total_pharmacy_spend,
    
    -- Contractual Savings: Money "saved" via provider negotiations
    sum(contractual_savings_gap) as total_negotiated_savings,
    
    -- Efficiency Calculation: Average cost per member
    round(avg(total_total_paid_amount), 2) as avg_cost_per_patient,

    -- 4. Operational & Clinical Outcomes
    sum(attended_visits) as total_attended_visits,
    sum(missed_visits) as total_missed_visits,
    
    -- Adherence Calculation: Percentage of missed care
    round(
        sum(missed_visits) * 100.0 / nullif(sum(attended_visits + missed_visits), 0), 
        2
    ) as missed_visit_pct,

    -- Clinical Intensity: Average touchpoints (Labs + Procs + Obs)
    round(
        avg(procedure_count + lab_count + observation_count), 
        2
    ) as avg_clinical_touchpoints_per_patient

from {{ ref('int_oncology__patient_master') }}
group by 1, 2, 3, 4, 5