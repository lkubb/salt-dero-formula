# vim: ft=sls

{#-
    *Meta-state*.

    This installs the dero package
    and then starts the ``derod`` service.
#}

include:
  - .package
  - .service
