#!jinja|yaml

{% from "mysql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('mysql:lookup')) %}

{% if datamap.client.pkgs|default({})|length > 0 %}
mysql_client:
  pkg:
    - installed
    - pkgs:
  {% for p in datamap.client.pkgs %}
      - {{ p.name }}
  {% endfor %}
{% endif %}
