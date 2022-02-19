# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as dero with context %}

Dero service is running:
  service.running:
    - name: {{ dero.service.name }}


# DERO : A secure, private blockchain with smart-contracts
# Usage:
#   derod [--help] [--version] [--testnet] [--debug]  [--sync-node] [--boltdb | --badgerdb] [--disable-checkpoints] [--socks-proxy=<socks_ip:port>] [--data-dir=<directory>] [--p2p-bind=<0.0.0.0:18089>] [--add-exclusive-node=<ip:port>]... [--add-priority-node=<ip:port>]...   [--min-peers=<11>] [--rpc-bind=<127.0.0.1:9999>] [--lowcpuram] [--mining-address=<wallet_address>] [--mining-threads=<cpu_num>] [--node-tag=<unique name>]
#   derod -h | --help
#   derod --version
# Options:
#   -h --help     Show this screen.
#   --version     Show version.
#   --testnet   Run in testnet mode.
#   --debug       Debug mode enabled, print log messages
#   --boltdb      Use boltdb as backend  (default on 64 bit systems)
#   --badgerdb    Use Badgerdb as backend (default on 32 bit systems)
#   --disable-checkpoints  Disable checkpoints, work in truly async, slow mode 1 block at a time
#   --socks-proxy=<socks_ip:port>  Use a proxy to connect to network.
#   --data-dir=<directory>    Store blockchain data at this location
#   --rpc-bind=<127.0.0.1:9999>    RPC listens on this ip:port
#   --p2p-bind=<0.0.0.0:18089>    p2p server listens on this ip:port, specify port 0 to disable listening server
#   --add-exclusive-node=<ip:port>  Connect to specific peer only
#   --add-priority-node=<ip:port> Maintain persistant connection to specified peer
#   --sync-node       Sync node automatically with the seeds nodes. This option is for rare use.
#   --min-peers=<11>      Number of connections the daemon tries to maintain
#   --lowcpuram          Disables some RAM consuming sections (deactivates mining/ultra compact protocol etc).
#   --mining-address=<wallet_address>         This address is rewarded when a block is mined sucessfully
#   --mining-threads=<cpu_num>         Number of CPU threads for mining
#   --node-tag=<unique name>  Unique name of node, visible to everyone
