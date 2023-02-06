# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``dero`` meta-state
    in reverse order, i.e.
    stops the service,
    uninstalls the package.
#}

include:
  - .service.clean
  - .package.clean
