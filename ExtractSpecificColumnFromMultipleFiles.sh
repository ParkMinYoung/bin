#!/bin/bash

. ~/.bash_function


if [ $# -ge 2 ];then

COL=$1
shift

unset STR
STR+="paste"
#LIST=$(cut -f 1 23me.tfam| cut -d"_" -f5 | sed 's/.CEL//' )
LIST=$@


# make command string 
for i in $LIST; do STR+=" <(cut -f $COL $i)"; done

# echo to stderr
echo $STR >&2
#echo $STR >> /dev/stderr

echo $LIST | tr "\n" "\t" | sed 's/\t$/\n/' && eval $STR

else
	usage "Column[4] XXX YYY ZZZ...."
fi


