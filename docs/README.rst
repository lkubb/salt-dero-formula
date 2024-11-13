.. _readme:

Dero Formula
============

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage `Dero <https://github.com/deroproject/derohe>`_ with Salt.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This formula only installs ``derod`` from released binaries on ``amd64`` systems. For Linux, there would be official builds for ``arm64`` and ``arm7`` as well. Wallet/Explorer/Miner might be supported at some point.
* It is mostly intended for a Linux server and support for other platforms is currently a sketch rather than functional.
* The tests are from boilerplate and not functional currently.

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


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



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
