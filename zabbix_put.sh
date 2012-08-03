#!/bin/bash

SRCFILE='file.dat'
DSTHOST='10.220.10.8'
DSTDIR='/tmp'

ZABBIX_GET="zabbix_get"

LINESIZE=256

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
"$ZABBIX_GET" -s "$DSTHOST" -k "system.run[base64 -id \"${DSTDIR}/${fname}.bzip2.b64\" | bunzip2 > \"${DSTDIR}/${fname}\" ; rm \"${DSTDIR}/${fname}.bzip2.b64\" ; md5sum \"${DSTDIR}/${fname}\"]"
md5sum "$SRCFILE"

rm -v "$tmpf"
