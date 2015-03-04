#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv, ['yaml'])['yaml'] %}

{% if datamap.salt.config.file.contents|default('')|length > 0 %}
mysql_salt_config:
  file:
    - managed
    - name: /etc/salt/mysql.cnf
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: mysql:salt:config:file
{% endif %}
