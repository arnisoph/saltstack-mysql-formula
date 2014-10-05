#!jinja|yaml

{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

include:
  - mysql
  - mysql._dbmgmt

{% set srv = datamap.server|default({}) %}

{% if salt['grains.get']('os') in ['Ubuntu', 'Debian'] %}
  {% for p in srv.pkgs|default({}) %}
    {% if 'debconf' in p %}
mysql_debconf_{{ p.name }}:
  debconf:
    - set
    - name: {{ p.name }}
    - data:
        {% for k, v in p.debconf|dictsort %}{{ k }}: {{ v }}
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
{% for p in srv.pkgs|default({}) %}
      - {{ p.name }}
{% endfor %}
  service:
    - {{ srv.service.ensure|default('running') }}
    - name: {{ srv.service.name|default('mysql') }}
    - enable: {{ srv.service.enable|default(True) }}
    - require:
      - pkg: mysql_server

{% if 'my' in srv.config.manage|default([]) %}
  {% set f = srv.config.my|default({}) %}
mysql_config_my:
  file:
    - managed
    - name: {{ f.path|default('/etc/mysql/my.cnf') }}
    - source: {{ f.template_path|default('salt://mysql/files/my.cnf') }}
    - template: {{ f.template_renderer|default('jinja') }}
    - mode: {{ f.mode|default(640) }}
    - user: {{ f.user|default('root') }}
    - group: {{ f.group|default('root') }}
    - watch_in:
      - service: mysql_server
{% endif %}
