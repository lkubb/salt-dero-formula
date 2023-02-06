# vim: ft=sls

{#-
    Removes the dero package.
    Has a dependency on `dero.service.clean`_.
    Blockchain data will be left.
#}

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
    - name: {{ dero.lookup.paths.bin | path_join(dero.lookup.pkg.release | string) }}
