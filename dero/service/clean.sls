# vim: ft=sls

{#-
    Stops ``derod`` and disables it at boot time.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

Dero is dead:
  service.dead:
    - name: {{ dero.lookup.service.name }}
    - enable: False
