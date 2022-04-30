# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

include:
  - {{ sls_service_clean }}

Dero service unit is absent:
  file.absent:
    - name: /etc/systemd/system/{{ dero.lookup.service.name }}.service

# This leaves the data behind to avoid accidental loss.
Dero is removed:
  file.absent:
    - name: {{ dero.basedir | path_join(dero.lookup.pkg.release | string) }}
