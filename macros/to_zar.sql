{# Jinja macro: reusable SQL snippet, like a small PL/SQL function but expanded at compile time #}
{% macro to_zar(column) %}
    cast(round({{ column }}, 2) as decimal(12,2))
{% endmacro %}
