#!/bin/bash
#
# Zabbix-put
# 
# Copyright 2012, Michal Belica <devel@beli.sk>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# - Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

ZABBIX_GET="zabbix_get"
LINESIZE=256

prog="zabbix_put"

function fail {
    echo "$prog FAIL: $1" >&2
    exit 1
}

function usage {
    echo "use: $prog <source_file> <destination_host> <destination_dir>"
    exit 0
}

[[ "$1" == "-h" ]] && usage

SRCFILE="$1"
DSTHOST="$2"
DSTDIR="$3"

[[ -n "$SRCFILE" && -n "$DSTHOST" && -n "$DSTDIR" ]] || fail "wrong command line arguments, use -h for help"

if [[ ! -r "$SRCFILE" ]] ; then
	echo "$SRCFILE missing"
	exit 1
fi

fname=`basename ${SRCFILE}`

tmpf=`mktemp` || exit 1
echo "$tmpf"

bzip2 -c9 "$SRCFILE" | base64 -w "$LINESIZE" > "$tmpf" || exit 1

cat "$tmpf" | while read line ; do
	"$ZABBIX_GET" -s "$DSTHOST" -k "system.run[echo \"$line\" >> \"${DSTDIR}/${fname}.bzip2.b64\" ; echo .]"
done
"$ZABBIX_GET" -s "$DSTHOST" -k \
    "system.run[base64 -id \"${DSTDIR}/${fname}.bzip2.b64\" | bunzip2 > \"${DSTDIR}/${fname}\" ; rm \"${DSTDIR}/${fname}.bzip2.b64\" ; md5sum \"${DSTDIR}/${fname}\"]"
md5sum "$SRCFILE"

rm -v "$tmpf"
