#!/bin/sh

source ~/.bash_function

#EXP=/home/adminrig/SolexaData
#DIR=$EXP/$1/Data/Intensities
#OUT=$EXP/Sequence.backup/$1.`date +%Y%m%d`

DIR=$1/Data/Intensities
OUT=Sequence.backup/$1.`date +%Y%m%d`

#if [ -d "$EXP/$1" ] && [ $# -eq 2 ]; then
if [ -d "$1" ] && [ $# -eq 2 ]; then

	# $1 : Experiment dir
	# $2 : Lane number


	TOTAL_LIST=$OUT.tmp
	SUB_LIST=$OUT.tmp.$2

	#rm -rf $TOTAL_LIST $SUB_LIST 
	find $DIR -maxdepth 1 | egrep "pos.txt|xml" | sort >> $TOTAL_LIST
	find $DIR/Offsets/ | sort >> $TOTAL_LIST
	find $DIR/BaseCalls/{L00?,Matrix,Phasing} | sort >> $TOTAL_LIST
	find $DIR/BaseCalls/ -maxdepth 1 -type f | egrep "(filter|xml|xsl)$" | sort >> $TOTAL_LIST

	egrep "s_[$2]|L00[$2]|config|xml$|xsl$" $TOTAL_LIST > $SUB_LIST

	tar cvjf $OUT.RunInfo.bz2 $1/InterOp/* $1/RunInfo.xml
	tar cvjf $OUT.$2.bz2 --files-from $SUB_LIST > $OUT.$2.bz2.log 2>&1

else 
	usage "101015_ILLUMINA-CD89F7_00002_FC_NEW02 1-8|345"
fi



#egrep "s_[1-4]|L00[1-4]|config|xml$|xsl$" 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.tmp > 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic

#tar cvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.KOBIC.Lane1-4.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic >&101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic.log &

#tar xvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2.list.Lane56 -C ../Lane56

# cp -av `find 2010* | grep bz2$` --target-directory=tmp/ --parents
