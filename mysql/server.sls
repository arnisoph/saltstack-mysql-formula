{% import_yaml "mysql/defaults.yaml" as rawmap %}
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
    - name: {{ datamap['server']['servicename'] }}
    - require:
      - pkg: mysql-server



