#!jinja|yaml

{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

include:
  - mysql
  - mysql._dbmgmt

{% if salt['grains.get']('os') in ['Ubuntu', 'Debian'] %}
  {% for p in datamap.server.pkgs|default({}) %}
    {% if 'debconf' in p %}
debconf_{{ p.name }}:
  debconf:
    - set
    - name: {{ p.name }}
    - data:
        {% for k, v in p.debconf.iteritems() %}{{ k }}: {{ v }}
        {% endfor %}
    - require_in:
      - pkg: mysql_server
    {% endif %}
  {% endfor %}
{% endif %}

mysql_server:
  pkg:
    - installed
    - pkgs:
{% for p in datamap.server.pkgs|default({}) %}
      - {{ p.name }}
{% endfor %}
  service:
    - {{ datamap.server.service.ensure|default('running') }}
    - name: {{ datamap.server.service.name|default('mysql') }}
    - enable: {{ datamap.server.service.enable|default(True) }}
    - require:
      - pkg: mysql_server
