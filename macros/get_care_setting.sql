{% macro get_care_setting(column_name) %}
    case 
        when {{ column_name }} ilike '%inpatient%' then 'Inpatient'
        when {{ column_name }} ilike '%emergency%' or {{ column_name }} ilike '%er%' then 'Emergency Room'
        when {{ column_name }} ilike '%outpatient%' then 'Outpatient'
        when {{ column_name }} ilike '%office%' or {{ column_name }} ilike '%clinic%' then 'Office Visit'
        else 'Other/Unknown'
    end
{% endmacro %}