Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``dero``
^^^^^^^^
*Meta-state*.

This installs the dero package
and then starts the ``derod`` service.


``dero.package``
^^^^^^^^^^^^^^^^
Installs the dero package only.

Releases are downloaded from GitHub by default
and the signatures on the hashdigest file verified
against the officially published public keys.


``dero.service``
^^^^^^^^^^^^^^^^
Starts ``derod`` and enables it at boot time.
Has a dependency on `dero.package`_.


``dero.clean``
^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``dero`` meta-state
in reverse order, i.e.
stops the service,
uninstalls the package.


``dero.package.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the dero package.
Has a dependency on `dero.service.clean`_.
Blockchain data will be left.


``dero.service.clean``
^^^^^^^^^^^^^^^^^^^^^^
Stops ``derod`` and disables it at boot time.


