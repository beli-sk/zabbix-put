Zabbix-put
==========

Upload files to remote host via Zabbix agent.

License
-------

The program is licensed under the terms of the [Simplified (2-cluase) BSD License](http://opensource.org/licenses/BSD-2-Clause) as approved by the Open Source Initiative.

Requirements
------------

Source host: zabbix agent installation (**zabbix_get** command), **mktemp**, **bzip2** and **base64** commands
Destination host: running Zabbix agent, **bunzip2** and **base64** commands

Usage
-----

Edit parameters at the head of zabbix_put.sh, then start it.
