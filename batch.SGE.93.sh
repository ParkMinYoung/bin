#!/bin/sh

source ~/.bash_function

if [ $# -eq 0 ];then
	usage "script xxx [yyy zzz ...]"
fi


SCRIPT=$(which $1)
shift

if [ -x $SCRIPT ] && [ $# -ge 1 ];then


	SUB=/home/adminrig/src/short_read_assembly/bin/sub
#SUB=~/src/short_read_assembly/bin/sub
	N=${SCRIPT%*.*}
	NN=${N##*/}
	N=${NN:0:3}

	TMP=TMP.q
	if [ ! -d $TMP ];then
		mkdir $TMP
	fi


	for i in $@
	    do 
		FILE=$(basename $i)
	    INN=${FILE:0:8}
	    QN=$N.$INN	
	    QN=$INN	

		log=$TMP/$QN

	    echo -e "qsub -N X$QN -q utl.q -j y -o $log -e $log  $SUB $SCRIPT $i\nsleep 2"
	done
else
	usage "script xxx [yyy zzz ...]"
fi
