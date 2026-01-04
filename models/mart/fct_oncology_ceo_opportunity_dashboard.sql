select 
    cancer_type,
    clinical_risk_segment,
    age_group,
    count(distinct person_id) as total_patients,
    
    -- Financial Breakdown (The "Where is the money going?" Analysis)
    sum(inpatient_spend) as total_inpatient_cost,
    sum(er_spend) as total_er_cost,
    sum(outpatient_spend) as total_outpatient_cost,
    sum(total_rx_paid) as total_pharmacy_cost,
    sum(total_med_paid + total_rx_paid) as total_spend,

    -- Key Performance Indicators (KPIs)
    round(sum(inpatient_spend) / nullif(sum(total_med_paid), 0) * 100, 2) as inpatient_cost_pct,
    round(avg(total_med_paid + total_rx_paid), 2) as avg_cost_per_patient,
    
    -- Outcomes & Savings Opportunities
    sum(missed_visits) as total_missed_visits,
    sum(abnormal_lab_count) as volume_of_abnormal_results,
    
    -- Savings Opportunity Calculation
    -- We assume reducing ER/Inpatient spend by 10% through better adherence
    round(sum(er_spend + inpatient_spend) * 0.10, 2) as potential_annual_savings
from {{ ref('int_oncology_patient_360_profile') }}
group by 1, 2, 3