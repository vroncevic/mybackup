<img align="right" src="https://raw.githubusercontent.com/vroncevic/mybackup/dev/docs/mybackup_logo.png" width="25%">

# Backup mechanism MySQL DB

**mybackup** is shell tool for controlling/operating MySQL server backup.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![mybackup_shell_checker](https://github.com/vroncevic/mybackup/actions/workflows/mybackup_shell_checker.yml/badge.svg)](https://github.com/vroncevic/mybackup/actions/workflows/mybackup_shell_checker.yml)

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/mybackup.svg)](https://github.com/vroncevic/mybackup/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/mybackup.svg)](https://github.com/vroncevic/mybackup/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/mybackup/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/mybackup/releases)** download and extract release archive.

To install **mybackup** type the following

```
tar xvzf mybackup-x.y.tar.gz
cd mybackup-x.y
cp -R ~/sh_tool/bin/   /root/scripts/mybackup/ver.x.y/
cp -R ~/sh_tool/conf/  /root/scripts/mybackup/ver.x.y/
cp -R ~/sh_tool/log/   /root/scripts/mybackup/ver.x.y/
```

Self generated setup script and execution
```
./mybackup_setup.sh 

[setup] installing App/Tool/Script mybackup
	Tue 30 Nov 2021 08:05:19 AM CET
[setup] clean up App/Tool/Script structure
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/mybackup/ver.2.0/
├── bin/
│   ├── backup.sh
│   ├── center.sh
│   ├── display_logo.sh
│   └── mybackup.sh
├── conf/
│   ├── mybackup.cfg
│   ├── mybackup.logo
│   └── mybackup_util.cfg
└── log/
    └── mybackup.log

3 directories, 8 files
lrwxrwxrwx 1 root root 46 Nov 30 08:05 /root/bin/mybackup -> /root/scripts/mybackup/ver.2.0/bin/mybackup.sh
```

Or You can use docker to create image/container.

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/mybackup/ver.x.y/bin/mybackup.sh /root/bin/mybackup

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating MySQL server backup
mybackup help
                                                                                                                                          
mybackup ver.2.0
Tue 30 Nov 2021 08:09:56 AM CET

[check_root] Check permission for current session? [ok]
[check_root] Done

                                                                          
                        ██                        ██                      
                       ░██                       ░██                      
   ██████████   ██   ██░██       ██████    █████ ░██  ██ ██   ██ ██████   
  ░░██░░██░░██ ░░██ ██ ░██████  ░░░░░░██  ██░░░██░██ ██ ░██  ░██░██░░░██  
   ░██ ░██ ░██  ░░███  ░██░░░██  ███████ ░██  ░░ ░████  ░██  ░██░██  ░██  
   ░██ ░██ ░██   ░██   ░██  ░██ ██░░░░██ ░██   ██░██░██ ░██  ░██░██████   
   ███ ░██ ░██   ██    ░██████ ░░████████░░█████ ░██░░██░░██████░██░░░    
  ░░░  ░░  ░░   ██     ░░░░░    ░░░░░░░░  ░░░░░  ░░  ░░  ░░░░░░ ░██       
               ░░                                               ░░        
                                                                          
	                                                   
		Info   github.io/mybackup ver.2.0
		Issue  github.io/issue
		Author vroncevic.github.io

  [USAGE] mybackup [OPTIONS]
  [OPTIONS]
  [OPTION] help
  # Get this info
  mybackup help
  [help | h] print this option
```

### Dependencies

**mybackup** requires next modules and libraries
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### Shell tool structure

**mybackup** is based on MOP.

Shell tool structure
```
sh_tool/
├── bin/
│   ├── backup.sh
│   ├── center.sh
│   ├── display_logo.sh
│   └── mybackup.sh
├── conf/
│   ├── mybackup.cfg
│   ├── mybackup.logo
│   └── mybackup_util.cfg
└── log/
    └── mybackup.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/mybackup/badge/?version=latest)](https://mybackup.readthedocs.io/projects/mybackup/en/latest/?badge=latest)

More documentation and info at
* [https://mybackup.readthedocs.io/en/latest/](https://mybackup.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 - 2024 by [vroncevic.github.io/mybackup](https://vroncevic.github.io/mybackup)

**mybackup** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/mybackup/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
