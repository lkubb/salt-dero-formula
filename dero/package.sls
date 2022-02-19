# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context -%}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

Dero user/group is present:
  user.present:
    - name: {{ dero.user }}
    - system: true
    - usergroup: true

Dero directory is present:
  file.directory:
    - name: {{ dero.basedir }}
    - user: root
    - group: {{ dero.rootgroup }}
    - makedirs: true

Dero is available:
  archive.extracted:
    - name: {{ dero.basedir }}
    - source:
      - https://github.com/deroproject/derosuite/releases/download/Version_P2P_bug_fix/dero_linux_amd64_2.2.1-0.Atlantis.Astrobwt+03072020.tar.gz
    - source_hash: 4bedb328b806cc1f523e3610219ec48789092714da02e84755d665200ea78729
    - user: {{ dero.user }}
    - group: {{ dero.group }}
    - require:
      - Dero directory is present

Dero service is available:
  file.managed:
    - name: /etc/systemd/system/{{ dero.service.name }}.service
    - source: {{ files_switch(['derod.service', 'derod.service.j2']) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ dero.rootgroup }}
    - makedirs: true
    - context: {{ {'dero': dero} | json }}

Dero datadir is available:
  file.directory:
    - name: {{ dero.datadir }}
    - user: {{ dero.user }}
    - group: {{ dero.group }}
    - makedirs: true
