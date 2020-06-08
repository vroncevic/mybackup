# Backup mechanism MySQL DB.

***mybackup*** is shell tool for control/operating MySQL server backup.

Developed in bash code: ***100%***.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/mybackup.svg)](https://github.com/vroncevic/mybackup/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/mybackup.svg)](https://github.com/vroncevic/mybackup/graphs/contributors)

<!-- START doctoc -->
**Table of Contents**

- [Installation](https://github.com/vroncevic/mybackup#installation)
- [Usage](https://github.com/vroncevic/mybackup#usage)
- [Dependencies](https://github.com/vroncevic/mybackup#dependencies)
- [Shell tool structure](https://github.com/vroncevic/mybackup#shell-tool-structure)
- [Docs](https://github.com/vroncevic/mybackup#docs)
- [Copyright and Licence](https://github.com/vroncevic/mybackup#copyright-and-licence)
<!-- END doctoc -->

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/mybackup/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf mybackup-x.y.z.tar.gz
cd mybackup-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/mybackup/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/mybackup/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/mybackup/ver.1.0/
```
![alt tag](https://raw.githubusercontent.com/vroncevic/mybackup/dev/docs/setup_tree.png)

Or You can use docker to create image/container.

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/mybackup/ver.1.0/bin/mybackup.sh /root/bin/mybackup

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating MySQL server backup
mybackup
```

### DEPENDENCIES

This tool requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

***mybackup*** is based on MOP.

Shell tool structure:
```
.
├── bin/
│   ├── backup.sh
│   └── mybackup.sh
├── conf/
│   ├── mybackup.cfg
│   └── mybackup_util.cfg
└── log/
    └── mybackup.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/mybackup/badge/?version=latest)](https://mybackup.readthedocs.io/projects/mybackup/en/latest/?badge=latest)

More documentation and info at:

* https://mybackup.readthedocs.io/en/latest/

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2018 by https://vroncevic.github.io/mybackup

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

