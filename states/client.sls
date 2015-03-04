#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv, ['yaml'])['yaml'] %}

# SLS includes/ excludes
include: {{ datamap.client.sls_include|default(['mysql._salt']) }}
extend: {{ datamap.client.sls_extend|default({}) }}

{% if datamap.client.pkgs|default({})|length > 0 %}
mysql_client:
  pkg:
    - installed
    - pkgs: {{ datamap.client.pkgs }}
{% endif %}
