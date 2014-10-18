#!jinja|yaml

{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

{% for d in salt['pillar.get']('mysql:databases', []) %}
mysql_database_{{ d.name }}:
  mysql_database:
    - {{ d.ensure|default('present') }}
    - name: {{ d.name }}
  {% if 'character_set' in d %}
    - character_set: {{ d.character_set }}
  {% endif %}
  {% if 'collate' in d %}
    - collate: {{ d.collate }}
  {% endif %}
    {# Salt MySQL conn config #}
  {% if salt['pillar.get']('mysql:salt:config:states', {})|length > 0 %}
    - connection_host: {{ salt['pillar.get']('mysql:salt:config:states:host', 'localhost') }}
    - connection_user: {{ salt['pillar.get']('mysql:salt:config:states:user', 'root') }}
    - connection_pass: {{ salt['pillar.get']('mysql:salt:config:states:pass', '-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ salt['pillar.get']('mysql:salt:config:states:charset', ' utf8') }}
    - connection_unix_socket: {{ salt['pillar.get']('mysql:salt:config:states:socket', '/var/run/mysqld/mysqld.sock') }}
  {% endif %}
  {% if 'default_file' in salt['pillar.get']('mysql:salt:config:states', {}) %}
    - connection_default_file: {{ salt['pillar.get']('mysql:salt:config:states:default_file') }}
  {% endif %}
    - require:
      - service: mysql_server
{% endfor %}

{% for u in salt['pillar.get']('mysql:users', []) %}
mysql_user_{{ u.name }}_{{ u.host|default('localhost') }}:
  mysql_user:
    - {{ u.ensure|default('present') }}
    - name: {{ u.name }}
    - host: {{ u.host|default('localhost') }}
  {% if 'password' in u %}
    - password: {{ u.password }}
  {% endif %}
  {% if 'password_hash' in u %}
    - password_hash: {{ u.password_hash }}
  {% endif %}
    - allow_passwordless: {{ u.passwordless|default(False) }}
    - unix_socket: {{ u.unix_socket|default(True) }}
    {# Salt MySQL conn config #}
  {% if salt['pillar.get']('mysql:salt:config:states', {})|length > 0 %}
    - connection_host: {{ salt['pillar.get']('mysql:salt:config:states:host', 'localhost') }}
    - connection_user: {{ salt['pillar.get']('mysql:salt:config:states:user', 'root') }}
    - connection_pass: {{ salt['pillar.get']('mysql:salt:config:states:pass', '-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ salt['pillar.get']('mysql:salt:config:states:charset', ' utf8') }}
    - connection_unix_socket: {{ salt['pillar.get']('mysql:salt:config:states:socket', '/var/run/mysqld/mysqld.sock') }}
  {% endif %}
  {% if 'default_file' in salt['pillar.get']('mysql:salt:config:states', {}) %}
    - connection_default_file: {{ salt['pillar.get']('mysql:salt:config:states:default_file') }}
  {% endif %}
    - require:
      - service: mysql_server
{% endfor %}

{% for g in salt['pillar.get']('mysql:grants', []) %}
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
  {% if salt['pillar.get']('mysql:salt:config:states', {})|length > 0 %}
    - connection_host: {{ salt['pillar.get']('mysql:salt:config:states:host', 'localhost') }}
    - connection_user: {{ salt['pillar.get']('mysql:salt:config:states:user', 'root') }}
    - connection_pass: {{ salt['pillar.get']('mysql:salt:config:states:pass', '-enM1kEmC1S8D50ABKXdz5hlXQTAm2z5') }}
    - connection_charset: {{ salt['pillar.get']('mysql:salt:config:states:charset', ' utf8') }}
    - connection_unix_socket: {{ salt['pillar.get']('mysql:salt:config:states:socket', '/var/run/mysqld/mysqld.sock') }}
  {% endif %}
  {% if 'default_file' in salt['pillar.get']('mysql:salt:config:states', {}) %}
    - connection_default_file: {{ salt['pillar.get']('mysql:salt:config:states:default_file') }}
  {% endif %}
    - require:
      - service: mysql_server
{% endfor %}
