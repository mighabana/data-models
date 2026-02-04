{% macro generate_schema_name(custom_schema_name, node) -%}
    {#
        This overrides dbt's default schema naming behaviour.
        It ensures dbt uses exactly the schema definied in dbt_project.yml
        and removes the default prefixing based on the profile schema.
    #}

    {%- if custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ target.schema }}
    {%- endif -%}
{%- endmacro %}
