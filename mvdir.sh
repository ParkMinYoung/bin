#!/bin/sh
# cp -urv 101213_ILLUMINA-CD89F7_00015_FC_NEW13.Sequence nas0 >& 101213_ILLUMINA-CD89F7_00015_FC_NEW13.Sequence.log &
# rm 101213_ILLUMINA-CD89F7_00015_FC_NEW13.Sequence

source ~/.bash_function

if [ -n "$1" ] && [ -d $1 ];then
	echo `date` cp $1 
	cp -urv $1 /isilon/GAIIx/ >& $1.log 
	if [ $? -eq 0 ];then
		echo `date` rm $1
		rm -rf $1
	fi
else
	usage 101213_ILLUMINA-CD89F7_00015_FC_NEW13.Sequence
fi


