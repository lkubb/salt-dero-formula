# vim: ft=sls

{#-
    Installs the dero package only.

    Releases are downloaded from GitHub by default
    and the signatures on the hashdigest file verified
    against the officially published public keys.
#}

include:
  - .install
