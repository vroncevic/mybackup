MYBACKUP
----------

.. toctree::
 :hidden:

 self


mybackup is shell tool for control/operating MySQL server backup.

Developed in bash code: 100%.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/mybackup.svg
   :target: https://github.com/vroncevic/mybackup/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/mybackup.svg
   :target: https://github.com/vroncevic/mybackup/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/mybackup/badge/?version=latest
   :target: https://mybackup.readthedocs.io/projects/mybackup/en/latest/?badge=latest

INSTALLATION
-------------
Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/mybackup/releases

To install this set of modules type the following:

.. code-block:: bash

   tar xvzf mybackup-x.y.z.tar.gz
   cd mybackup-x.y.z
   cp -R ~/sh_tool/bin/   /root/scripts/mybackup/ver.1.0/
   cp -R ~/sh_tool/conf/  /root/scripts/mybackup/ver.1.0/
   cp -R ~/sh_tool/log/   /root/scripts/mybackup/ver.1.0/

DEPENDENCIES
-------------
This tool requires these other modules and libraries:

.. code-block:: bash

   sh_util https://github.com/vroncevic/sh_util

SHELL TOOL STRUCTURE
---------------------
mybackup is based on MOP.

Shell tool structure:

.. code-block:: bash

   .
   ├── bin/
   │   ├── backup.sh
   │   └── mybackup.sh
   ├── conf/
   │   ├── mybackup.cfg
   │   └── mybackup_util.cfg
   └── log/
       └── mybackup.log

COPYRIGHT AND LICENCE
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2018 by https://vroncevic.github.io/mybackup

This tool is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

