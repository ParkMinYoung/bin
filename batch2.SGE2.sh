#!/bin/sh

source ~/.bash_function

if [ $# -eq 0 ];then
	usage "script xxx [yyy zzz ...]"
fi


SCRIPT=$(which $1)
shift

if [ -x $SCRIPT ] && [ $# -ge 2 ];then


	SUB=~/src/short_read_assembly/bin/sub.2
	N=${SCRIPT%*.*}
	NN=${N##*/}
	N=${NN:0:3}

	echo $@ | xargs -n 2 |perl -F'\s' -MFile::Basename -sanle'$f=fileparse($F[0]); $i=substr $f,0,5;print "qsub -N S$i $sub $sc $_\nsleep 20"' -- -sc=$SCRIPT -sub=$SUB

else
	usage "script xxx [yyy zzz ...]"
fi
