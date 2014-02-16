{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

{% if grains['os'] in ['Ubuntu', 'Debian'] %}
  {% for p in datamap['server']['pkgs'] %}
    {% if 'debconf' in p %}
debconf-{{ p['name'] }}:
  debconf:
    - set
    - name: {{ p['name'] }}
    - data:
        {% for k, v in p['debconf'].iteritems() %}{{ k }}: {{ v }}
        {% endfor %}
    - require_in:
      - pkg: mysql-server
    {% endif %}
  {% endfor %}
{% endif %}

mysql-server:
  pkg:
    - installed
    - pkgs:
{% for p in datamap['server']['pkgs'] %}
      - {{ p['name'] }}
{% endfor %}
  service:
    - running
    - name: {{ datamap['server']['service']['name'] }}
    - enable: {{ datamap['server']['service']['enable'] }}
    - require:
      - pkg: mysql-server


{% if datamap['remove_anon_users'] == True %}
remove_anon_mysqluser_local:
  mysql_user:
    - absent
    #- name: ''   {# TODO name? #}
    - host: localhost

remove_anon_mysqluser_fqdn:
  mysql_user:
    - absent
    #- name: ''   {# TODO name? #}
    - host: {{ grains['host'] }} {# #TODO fqdn?! #}
{% endif %}

{% if datamap['remove_test_db'] == True %}
remove_test_db:
  mysql_database:
    - absent
    - name: test
{% endif %}

{% if datamap['remove_test_db_grant'] == False %} {# TODO debug #}
remove_test_db_grant:
  mysql_grants.absent:
    - grant: all privileges
    - database: test
#    - user: {# #TODO <= test state #}
{% endif %}

{# TODO mysql pwd file #}
