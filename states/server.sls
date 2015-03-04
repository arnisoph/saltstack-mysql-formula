#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv, ['yaml'])['yaml'] %}

# SLS includes/ excludes
include: {{ datamap.server.sls_include|default(['mysql._dbmgmt']) }}
extend: {{ datamap.server.sls_extend|default({}) }}

{% set srv = datamap.server|default({}) %}

{% if salt['grains.get']('os_family') in ['Debian'] %}
mysql_debconf_mysql-server:
  debconf:
    - set
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ srv.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ srv.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}'}
        'mysql-server/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: mysql_server
{% endif %}

mysql_server:
  pkg:
    - installed
    - pkgs: {{ srv.pkgs }}
  service:
    - {{ srv.service.ensure|default('running') }}
    - name: {{ srv.service.name }}
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
