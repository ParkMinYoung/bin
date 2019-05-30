#!/bin/sh
. ~/.bash_function

help=
"
XXX file have 2 cols.
1 col         2 col
old1          new1
old2          new2
old3          new3
.
.
.

Extetion list ars CEL[ JPT DAT....]
"


if [ -f "$1" ] & [ $# -ge 2 ]; then
F=$1
shift
mkdir New Old

for i in $@;
	do
	perl -F'\t' -asnle'$old="$F[0].$ext"; $new="New/$F[1].$ext"; print "ln $old $new; mv $old Old"' -- -ext=$i $F
done

else
	echo $help
	usage "XXX [Extention list]"
fi




