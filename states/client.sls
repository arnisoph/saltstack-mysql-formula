#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv) %}
{% set comp_type = datamap['type'] %}
{% set comp_data = datamap[comp_type]|default({}) %}

# SLS includes/ excludes
include: {{ comp_data.client.sls_include|default(['mysql._salt']) }}
extend: {{ comp_data.client.sls_extend|default({}) }}

{% if comp_data.client.pkgs|default({})|length > 0 %}
{{ comp_type }}_client:
  pkg:
    - installed
    - pkgs: {{ comp_data.client.pkgs }}
{% endif %}
