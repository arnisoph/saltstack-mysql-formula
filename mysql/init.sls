#!jinja|yaml

{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

include:
  - mysql
  - mysql._dbmgmt

{% if salt['pillar.get']('mysql:salt:config:file', '')|length > 0 %}
salt_mysql_config:
  file:
    - managed
    - name: /etc/salt/mysql.cnf
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: mysql:salt:config:file
{% endif %}
