{% macro classify_spend(total_paid_col) %}
    case 
        when {{ total_paid_col }} >= 50000 then 'High Spend'
        when {{ total_paid_col }} >= 10000 then 'Moderate Spend'
        when {{ total_paid_col }} > 0 then 'Low Spend'
        else 'No Spend'
    end
{% endmacro %}
