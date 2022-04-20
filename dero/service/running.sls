# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

dero-service-running-service-running:
  service.running:
    - name: {{ dero.lookup.service.name }}
    - enable: True
