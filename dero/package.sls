# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context -%}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

Salt can manage GPG:
  # make sure gpg and python-gpg are available
  pkg.installed:
    - pkgs: {{ dero.pkg.required | json }}
  # needed to avoid exception when running gpg.get_key in unless below
  cmd.run:
    - name: gpg --list-keys
    - unless:
      - test -d /root/.gnupg

# there is another pubkey, but this one is used for releases atm
Dero release signing pubkey file is present:
  file.managed:
    - name: /tmp/dero/pubkey2.gpg
    - source:
      - https://raw.githubusercontent.com/deroproject/documentation/master/captainKEY2.asc
      - salt://dero/files/captain2.pub
    - skip_verify: true
    - makedirs: true

Dero release signing pubkey is imported:
  module.run:
    - gpg.import_key:
      - filename: /tmp/dero/pubkey2.gpg
    - unless:
      - fun: gpg.get_key
        fingerprint: DED1FEF44297A15CAD9AE28318CDB3ED5E85D2D4
    - require:
      - Dero release signing pubkey file is present
      - Salt can manage GPG

Dero release signing pubkey is actually present:
  module.run:
    - gpg.get_key:
      - fingerprint: DED1FEF44297A15CAD9AE28318CDB3ED5E85D2D4
    - require:
      - Dero release signing pubkey is imported

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

Dero release hashes are available:
  file.managed:
    - name: /tmp/dero/hashes.txt.asc
    - source: {{ dero.pkg.source_hash.format(dero.pkg.release) }}
    - skip_verify: true

Dero release hashes are signed by Dero pubkey:
  module.run:
    - gpg.verify:
      - filename: /tmp/dero/hashes.txt.asc
    - require:
      - Dero release hashes are available
      - Dero release signing pubkey is actually present

Dero is available:
  archive.extracted:
    - name: {{ dero.basedir }}
    - source: {{ dero.pkg.source.format(dero.pkg.release) }}
    - source_hash: /tmp/dero/hashes.txt.asc
    - user: {{ dero.user }}
    - group: {{ dero.group }}
    - require:
      - Dero directory is present
      - Dero release hashes are signed by Dero pubkey

# this currently assumes systemd @FIXME
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
