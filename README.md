Zabbix-put
==========

Upload files to remote host via Zabbix agent.

License
-------

The program is licensed under the terms of the [Simplified (2-cluase) BSD License](http://opensource.org/licenses/BSD-2-Clause) as approved by the Open Source Initiative.

Requirements
------------

_Source host_: zabbix agent installation (**zabbix_get** command), **mktemp**, **bzip2** and **base64** commands

_Destination host_: running Zabbix agent with _EnableRemoteCommands_ enabled, **bunzip2** and **base64** commands

Usage
-----

zabbix_put.sh takes following command line arguments:

    zabbix_put.sh <source_file> <destination_host> <destination_dir>

It first compresses _source file_ with bzip2 and encodes it in base64, splits it into 768 byte long lines and send it line by line to _destination host_ using _zabbix_get_ with _system.run[]_ key for each line.
Then it starts bunzip2 and base64 on the remote host to decode the file and shows MD5 sum of the remote file and local file for the user to compare.
