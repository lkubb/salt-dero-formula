# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Salt can manage GPG:
  # make sure gpg and python-gpg are available
  pkg.installed:
    - pkgs: {{ dero.lookup.pkg.required | json }}
  # needed to avoid exception when running gpg.get_key in unless below
  cmd.run:
    - name: gpg --list-keys
    - unless:
      - test -d "${GNUPG_HOME:-$HOME/.gnupg}"
      # the above does not work somehow
      - test -d /root/.gnupg

Dero user/group is present:
  user.present:
    - name: {{ dero.lookup.user }}
    - system: true
    - usergroup: true

Dero directory is present:
  file.directory:
    - name: {{ dero.lookup.paths.bin }}
    - user: root
    - group: {{ dero.lookup.rootgroup }}
    - makedirs: true

# there is another pubkey, but this one is used for releases atm
Dero release signing pubkey file is present:
  file.managed:
    - name: /tmp/dero/pubkey2.gpg
    - source:
      - https://raw.githubusercontent.com/deroproject/documentation/master/captainKEY2.asc
      - salt://dero/files/default/captain2.pub
    - source_hash: be43b6934f4414f1b237b865f33a55d449fd211ef2f4e395cde87167392058ba
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

Dero release hashes are available:
  file.managed:
    - name: /tmp/dero/hashes.txt.asc
    - source: {{ dero.lookup.pkg.source_hash.format(dero.release) }}
    - skip_verify: true

{%- if "gpg" not in salt["saltutil.list_extmods"]().get("states", []) %}

# Ensure the following does not run without the key being present.
# The official gpg modules are currently big liars and always report
# `Yup, no worries! Everything is fine.`
Dero release signing pubkey is actually present:
  module.run:
    - gpg.get_key:
      - fingerprint: DED1FEF44297A15CAD9AE28318CDB3ED5E85D2D4
    - require:
      - Dero release signing pubkey is imported

Dero release hashes are signed by Dero pubkey:
  test.configurable_test_state:
    - name: Check if the downloaded web vault archive has been signed by the author.
    - changes: False
    - result: >
        __slot__:salt:gpg.verify(filename=/tmp/web-vault-{{ warden.version_web_vault }}.tar.gz,
        signature=/tmp/web-vault-{{ warden.version_web_vault }}.tar.gz.asc).res
    - require:
      - Dero release hashes are available
      - Dero release signing pubkey is actually present
{%- else %}

Dero release hashes are signed by Dero pubkey:
  gpg.verified:
    - name: /tmp/dero/hashes.txt.asc
    - signed_by_any: DED1FEF44297A15CAD9AE28318CDB3ED5E85D2D4
    - require:
      - Dero release hashes are available
{%- endif %}

Dero is installed:
  archive.extracted:
    - name: {{ dero.lookup.paths.bin | path_join(dero.release | string) }}
    - source: {{ dero.lookup.pkg.source.format(dero.release, dero.lookup.pkg.name | replace("-", "_")) }}
    - source_hash: /tmp/dero/hashes.txt.asc
    - source_hash_name: 'SHA512 ({{ dero.lookup.pkg.name | replace("-", "_") }}.tar.gz) ='
    - user: {{ dero.lookup.user }}
    - group: {{ dero.lookup.group }}
    # 2 levels are needed to just dump the files
    - options: --strip-components=2
    # this is needed because of the above
    - enforce_toplevel: false
    - require:
      - Dero directory is present
      - Dero release hashes are signed by Dero pubkey

# this currently assumes systemd @FIXME
Dero service unit is installed:
  file.managed:
    - name: /etc/systemd/system/{{ dero.lookup.service.name }}.service
    - source: {{ files_switch(["derod.service", "derod.service.j2"]) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ dero.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"dero": dero} | json }}

Dero working dir is available:
  file.directory:
    - name: {{ dero.lookup.paths.working }}
    - user: {{ dero.lookup.user }}
    - group: {{ dero.lookup.group }}
    - mode: '0710'

# To be able to limit writes to the log file only in the systemd unit,
# it needs to exist before it is launched.
Dero log file exists:
  file.managed:
    - name: {{ dero.lookup.paths.bin | path_join(dero.release | string, dero.lookup.pkg.daemon ~ ".log") }}
    - user: {{ dero.lookup.user }}
    - group: {{ dero.lookup.group }}
    - mode: '0600'
    - replace: false

Dero datadir is available:
  file.directory:
    - name: {{ dero.lookup.paths.data }}
    - user: {{ dero.lookup.user }}
    - group: {{ dero.lookup.group }}
    - makedirs: true
    - unless:
      # Check if path is somewhere on network share, might not be able to ensure ownership.
      # @TODO proper check/config
      - >-
          test -d '{{ dero.lookup.paths.data }}' &&
          df -P '{{ dero.lookup.paths.data }}' |
          awk 'BEGIN {e=1} $NF ~ /^\/.+/ { e=0 ; print $1 ; exit } END { exit e }'
