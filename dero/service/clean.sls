# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

dero-service-clean-service-dead:
  service.dead:
    - name: {{ dero.lookup.service.name }}
    - enable: False
