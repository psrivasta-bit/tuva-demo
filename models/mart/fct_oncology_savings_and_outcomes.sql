select 
    cancer_type,
    spend_segment,
    count(distinct person_id) as total_patients,
    sum(med_paid) as total_medical_spend,
    sum(rx_paid) as total_pharmacy_spend,
    sum(total_spend) as total_cost_of_care,
    -- Savings Metric: Contractual Gap
    sum(med_allowed - med_paid) as negotiated_savings,
    -- Outcome Metric: Clinical Intensity vs Cost
    round(avg(proc_count + lab_count), 2) as avg_clinical_touchpoints
from {{ ref('int_oncology_patient_master') }}
group by 1, 2