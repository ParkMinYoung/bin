#!/bin/sh

source ~/.bash_function


if [ $# -eq 3 ] && [ -f "$1" ] && [ -f "$3" ];then

# $1 : tmp
# $2 : lane numbers
# $3 : bz2 file

	OUTPUT=$1.$2
	OUTPUTBZ2=$1.$2.bz2
	echo "[`date`] grep lanes $2"
	egrep "s_[$2]|L00[$2]|config|xml$|xsl$" $1 > $OUTPUT

	echo "[`date`] uncompression : tar xvjf $3 --files-from $OUTPUT >& $OUTPUT.uncompress.log"
	tar xvjf $3 --files-from $OUTPUT >& $OUTPUT.uncompress.log  

	echo "[`date`] compression : tar cvjf $OUTPUTBZ2 --files-from $OUTPUT >& $OUTPUT.log" 
	tar cvjf $OUTPUTBZ2 --files-from $OUTPUT >& $OUTPUT.log

else
	usage "101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.tmp [1-4|1267] 101015_ILLUMINACD89F7_00002_FC_NEW02.20101020.bz2 >& tmp.log &"
fi


## umcompress file for specific lanes
#tar xvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2.list.Lane56 -C ../Lane56

## cp files specific folder from list
# cp -av `find 2010* | grep bz2$` --target-directory=tmp/ --parents
