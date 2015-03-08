==========================
saltstack-mysql-formula
==========================

.. image:: http://img.shields.io/github/tag/bechtoldt/saltstack-mysql-formula.svg
    :target: https://github.com/bechtoldt/saltstack-mysql-formula/tags

.. image:: http://issuestats.com/github/bechtoldt/saltstack-mysql-formula/badge/issue
    :target: http://issuestats.com/github/bechtoldt/saltstack-mysql-formula

.. image:: https://api.flattr.com/button/flattr-badge-large.png
    :target: https://flattr.com/submit/auto?user_id=bechtoldt&url=https%3A%2F%2Fgithub.com%2Fbechtoldt%2Fsaltstack-mysql-formula

SaltStack formula to set up and configure MySQL and MariaDB, a relational database management system

.. contents::
    :backlinks: none
    :local:

Instructions
------------

Please refer to https://github.com/bechtoldt/formula-docs to learn how to use
this formula, how it is built and how you can add your changes.


Compatibility
-------------

See <TODO> file to see which Salt versions and operating systems are supported.


Dependencies
------------

None


Contributing
------------

Contributions are welcome! All development guidelines we ask you to follow can
be found at https://github.com/bechtoldt/formula-docs.

In general:

1. Fork this repo on Github
2. Add changes, test them, update docs (README.rst) if possible
3. Submit your pull request (PR) on Github, wait for feedback


TODO
----

* add instructions how to use formhelper, add information about it in the
  formula-docs (dependency), show up alternative?
* table/ matrix: os/salt compatibility (dedicated file)
* add list of available states
* manage self-built packages
* create galera formula that deploys a notify script (e.g. https://github.com/gguillen/galeranotify)
* add doc how to deploy a galera/ xtrabackup cluster
* rewrite using #!py renderer
* add custom grain modules to determine replication status and more


Additional Resources
--------------------

Recommended formulas:

* `saltstack-repos-formula <https://github.com/bechtoldt/saltstack-repos-formula>`_: repo management (see ``pillar_examples/mariadb.sls``)
* `saltstack-percona-formula <https://github.com/bechtoldt/saltstack-percona-formula>`_: installation of Percona packages

Further reading:

* Galera cluster setup: http://linsenraum.de/erkules_int/2014/01/installing-mariadb-galera-cluster-on-debianubuntu.html
* Galera cluster setup: https://www.digitalocean.com/community/tutorials/how-to-configure-a-galera-cluster-with-mariadb-on-ubuntu-12-04-servers
