#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv) %}

{% if datamap.salt.config.file.contents|default('')|length > 0 %}
{{ comp_type }}_salt_config:
  file:
    - managed
    - name: /etc/salt/mysql.cnf
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: mysql:lookup:salt:config:file
{% endif %}
