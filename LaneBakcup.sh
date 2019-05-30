#!/bin/sh

source ~/.bash_function


if [ $# -eq 2 ] && [ -f "$1" ];then

	OUTPUT=$1.$2
	egrep "s_[$2]|L00[$2]|config|xml$|xsl$" $1 > $OUTPUT

	tar cvjf $OUTPUT.bz2 --files-from $OUTPUT >& $OUTPUT.log  

else
	usage "101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.tmp [1-4|1267]"
fi


## umcompress file for specific lanes
#tar xvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2.list.Lane56 -C ../Lane56

## cp files specific folder from list
# cp -av `find 2010* | grep bz2$` --target-directory=tmp/ --parents
