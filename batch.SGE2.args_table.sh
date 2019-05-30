#!/bin/bash

source ~/.bash_function

 ##if [ $# -eq 0 ];then
 ##	usage "script args_table"
 ##fi



default_sub=/home/adminrig/src/short_read_assembly/bin/sub.2


if [ -x $SCRIPT ] && [ -f "$2" ];then

	SCRIPT=$(readlink -f $1)
	
	SUB=${3:-$default_sub}
	N=${SCRIPT%*.*}
	NN=${N##*/}
	N=${NN:0:3}
	
	while read A B;
	do
		B=${B/$(echo -e "\t")/ }
#		qsub -N $N-$A  -j y -e TMP -o TMP  $SUB $SCRIPT $B
		echo -e "qsub -N $N-$A -q utl.q -j y -o TMP -e TMP $SUB $SCRIPT $B\nsleep 2"
#		echo -e "qsub -q utl.q@cp04-13.local -N $N-$A -j y -o TMP -e TMP $SUB $SCRIPT $B"

#		echo $A
#		echo $B
	done < $2


else

cat << EOF

============================================================

${BLUE}args_table format : more than two${NORM}

${RED}1. Job Name${NORM}
${RED}2. ARGS 1,2,3.... by tab delimited${NORM}


============================================================
EOF


	usage "script args_table [sub files: /home/adminrig/src/short_read_assembly/bin/sub.2]"
fi
