{% import_yaml "mysql/defaults.yaml" as rawmap %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

mysql-client:
  pkg:
    - installed
    - pkgs:
{% for p in datamap['client']['pkgs'] %}
      - {{ p['name'] }}
{% endfor %}
