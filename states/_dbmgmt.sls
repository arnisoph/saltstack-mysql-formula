#!jinja|yaml

{% set datamap = salt['formhelper.get_defaults']('mysql', saltenv) %}
{% set comp_type = datamap['type'] %}
{% set comp_data = datamap[comp_type]|default({}) %}

# SLS includes/ excludes
include:
  - mysql._salt

{% if salt['grains.get']('os_family') in ['RedHat', 'Suse' ] %}
{{ comp_type }}_rootpwd:
  cmd.run:
    - name: mysqladmin --user root password '{{ comp_data.server.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}'
    - unless: mysql --user root --password='{{ comp_data.server.rootpwd|default('-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}' --execute="SELECT 1;"
    - require:
      - sls: mysql.server
{% endif %}

{% for id, d in comp_data.databases|default({})|dictsort %}
{{ comp_type }}_database_{{ d.name|default(id) }}:
  mysql_database:
    - {{ d.ensure|default('present') }}
    - name: {{ d.name|default(id) }}
  {% if 'character_set' in d %}
    - character_set: {{ d.character_set }}
  {% endif %}
  {% if 'collate' in d %}
    - collate: {{ d.collate }}
  {% endif %}
    {# Salt MySQL conn config #}
  {% if datamap.salt.config.states|length > 0 %}
    - connection_host: {{ datamap.salt.config.states.host|default('localhost') }}
    - connection_user: {{ datamap.salt.config.states.user|default('root') }}
    - connection_pass: {{ datamap.salt.config.states.pass|default('enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ datamap.salt.config.states.charset|default('utf8') }}
    - connection_unix_socket: {{ datamap.salt.config.states.socket|default('/var/run/mysqld/mysqld.sock') }}
  {% elif 'default_file' in datamap.salt.config.states %}
    - connection_default_file: {{ datamap.salt.config.states.default_file }}
  {% endif %}
    - require:
      - sls: mysql.server
{% endfor %}


{% for u in comp_data.users|default([]) %}
mysql_user_{{ u.name }}_{{ u.host|default('localhost') }}:
  mysql_user:
    - {{ u.ensure|default('present') }}
    - name: {{ u.name }}
    - host: {{ u.host|default('localhost') }}
  {% if 'password' in u %}
    - password: {{ u.password }}
  {% elif 'password_hash' in u %}
    - password_hash: {{ u.password_hash }}
  {% endif %}
    - allow_passwordless: {{ u.passwordless|default(False) }}
    - unix_socket: {{ u.unix_socket|default(True) }}
    {# Salt MySQL conn config #}
  {% if datamap.salt.config.states|length > 0 %}
    - connection_host: {{ datamap.salt.config.states.host|default('localhost') }}
    - connection_user: {{ datamap.salt.config.states.user|default('root') }}
    - connection_pass: {{ datamap.salt.config.states.pass|default('enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ datamap.salt.config.states.charset|default('utf8') }}
    - connection_unix_socket: {{ datamap.salt.config.states.socket|default('/var/run/mysqld/mysqld.sock') }}
  {% elif 'default_file' in datamap.salt.config.states %}
    - connection_default_file: {{ datamap.salt.config.states.default_file }}
  {% endif %}
  {% if u.name == 'debian-sys-maint' %}
    - require_in:
      - service: {{ comp_type }}_server
    - require:
      - pkg: {{ comp_type }}_server
  {% else  %}
    - require:
      - sls: mysql.server
  {% endif %}


  {% if 'defaults_file' in u %}
    {% set df = u.defaults_file %}
mysql_user_{{ u.name }}_{{ u.host|default('localhost') }}_defaults_file:
  file:
    - {{ df.ensure|default('managed') }}
    - name: {{ salt['user.info'](df.user|default('root')).home|default('/root') }}/.my.{{ u.name }}.cnf
    - mode: 600
    - user: {{ df.user|default('root') }}
    - group: {{ df.group|default('root') }}
    - contents: |
        [client]
      {%- if 'socket' in df %}
        socket = {{ df.socket }}
      {%- else %}
        host = {{ df.host|default(u.host|default('localhost')) }}
      {%- endif %}
        user = {{ u.name }}
        password = {{ u.password }}
  {% endif %}
{% endfor %}


{% for g in comp_data.grants|default([]) %}
mysql_grant_{{ g.user }}_{{ g.host|default('localhost') }}_{{ g.database|default('all') }}:
  mysql_grants:
    - {{ g.ensure|default('present') }}
    - user: {{ g.user }}
    - host: {{ g.host|default('localhost') }}
    - database: '{{ g.database|default('*.*') }}'
    - grant: {{ g.grant|default(['all privileges'])|join(',') }}
    - grant_option: {{ g.grant_option|default(False) }}
    - escape: {{ g.escape|default(True) }}
    - revoke_first: {{ g.revoke|default(False) }}
    {# Salt MySQL conn config #}
  {% if datamap.salt.config.states|length > 0 %}
    - connection_host: {{ datamap.salt.config.states.host|default('localhost') }}
    - connection_user: {{ datamap.salt.config.states.user|default('root') }}
    - connection_pass: {{ datamap.salt.config.states.pass|default('enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ datamap.salt.config.states.charset|default('utf8') }}
    - connection_unix_socket: {{ datamap.salt.config.states.socket|default('/var/run/mysqld/mysqld.sock') }}
  {% elif 'default_file' in datamap.salt.config.states %}
    - connection_default_file: {{ datamap.salt.config.states.default_file }}
  {% endif %}
    - require:
      - sls: mysql.server
{% endfor %}
