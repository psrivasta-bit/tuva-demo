{% macro is_oncology_dx(column_name) %}
    -- Returns true if the ICD-10 code is in the Malignant Neoplasm range (C00-C96)
    ({{ column_name }} ilike 'C%')
{% endmacro %}