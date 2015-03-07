#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv, ['yaml'])['yaml'] %}
{% set comp_type = datamap['type'] %}
{% set comp_data = datamap[comp_type]|default({}) %}

# SLS includes/ excludes
include: {{ comp_data.server.sls_include|default(['mysql._dbmgmt']) }}
extend: {{ comp_data.server.sls_extend|default({}) }}

{% if salt['grains.get']('os_family') in ['Debian'] %}
{{ comp_type }}_debconf:
  debconf:
    - set
    - name: {{ comp_type }}-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ comp_data.server.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ comp_data.server.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}'}
        'mysql-server/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: {{ comp_type }}_server
{% endif %}


{{ comp_type }}_server:
  pkg:
    - installed
    - pkgs: {{ comp_data.server.pkgs }}
  service:
    - {{ comp_data.server.service.ensure|default('running') }}
    - name: {{ comp_data.server.service.name }}
    - enable: {{ comp_data.server.service.enable|default(True) }}
    - require:
      - pkg: {{ comp_type }}_server


{% if 'my' in comp_data.server.config.manage|default([]) %}
  {% set f = comp_data.server.config.my|default({}) %}
{{ comp_type }}_config_my:
  file:
    - managed
    - name: {{ f.path|default('/etc/mysql/my.cnf') }}
    - source: {{ f.template_path|default('salt://mysql/files/my.cnf') }}
    - template: {{ f.template_renderer|default('jinja') }}
    - mode: {{ f.mode|default(640) }}
    - user: {{ f.user|default('root') }}
    - group: {{ f.group|default('root') }}
    - watch_in:
      - service: {{ comp_type }}_server
{% endif %}
