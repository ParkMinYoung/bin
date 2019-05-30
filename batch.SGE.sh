#!/bin/sh

source ~/.bash_function

if [ $# -eq 0 ];then
	usage "script xxx [yyy zzz ...]"
fi


SCRIPT=$(which $1)
shift

if [ -x $SCRIPT ] && [ $# -ge 1 ];then

	Q=high.q
	SUB=~/src/short_read_assembly/bin/sub
	N=${SCRIPT%*.*}
	NN=${N##*/}
	N=${NN:0:3}


	mkdir TMP
	for i in $@
	    do 
	    IN=${i##*/}
	    INN=${IN:0:5}
	    QN=$N.$INN	
		HOST=node0$(perl -e'print int(rand(2))+2').local
#echo -e "qsub -l hostname=node01.local -q $Q -N $QN -j y -e TMP -o TMP $SUB $SCRIPT $i\nsleep 15"
		echo -e "qsub -l hostname=$HOST -q $Q -N $QN -j y -e TMP -o TMP $SUB $SCRIPT $i\nsleep 5"
#echo -e "qsub -N $QN $SUB $SCRIPT $i\nsleep 15"
	done
else
	usage "script xxx [yyy zzz ...]"
fi
