#!/bin/sh

source ~/.bash_function

if [ $# -eq 0 ];then
	usage "script fixed_xxx [yyy zzz ...]"
fi


SCRIPT=$(which $1)
shift
FIXED=$1
shift

if [ -x $SCRIPT ] && [ $# -ge 2 ];then


	SUB=~/src/short_read_assembly/bin/sub
	N=${SCRIPT%*.*}
	NN=${N##*/}
	N=${NN:0:3}

	
	ls $@ | perl -F'\s' -MFile::Basename -sanle'$f=fileparse($F[0]); $i=substr $f,0,5;print "qsub -N S$i $sub $sc $_ $fixed\nsleep 20"' -- -sc=$SCRIPT -sub=$SUB -fixed=$FIXED

else
	usage "script fixed_xxx [yyy zzz ...]"
fi
