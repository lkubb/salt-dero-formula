# -*- coding: utf-8 -*-
# vim: ft=yaml
---
dero:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    service:
      name: derod
    basedir: /opt/dero
    datadir: /opt/dero/data
    group: dero
    pkg:
      daemon: derod-linux-amd64
      explorer: explorer-linux-amd64
      miner: dero-miner-linux-amd64
      name: dero-linux-amd64
      required:
        - gpg
        - python-gnupg
      simulator: simulator-linux-amd64
      source: https://github.com/deroproject/derohe/releases/download/Release{}/{}.tar.gz
      source_hash: https://github.com/deroproject/derohe/releases/download/Release{}/checksum.txt.asc
      wallet: dero-wallet-cli-linux-amd64
    user: dero
  datadir_requires_mount: false
  release: 66

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://dero/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   dero-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      dero-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
