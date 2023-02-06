# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

include:
  - {{ sls_package_install }}

Dero is running:
  service.running:
    - name: {{ dero.lookup.service.name }}
    - enable: True
    # The configuration can only be passed as cli parameters.
    - watch:
      - Dero service unit is installed
