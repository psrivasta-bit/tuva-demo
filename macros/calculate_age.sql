{% macro calculate_age(birth_date_col) %}
    floor(date_diff('day', {{ birth_date_col }}, current_date) / 365.25)
{% endmacro %}