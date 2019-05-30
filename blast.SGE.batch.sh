#!/bin/sh


source ~/.bash_function

if [ $# -ge 1 ]; then
	DB=/home/adminrig/BLAST/DB/nr
	SUB=~/src/short_read_assembly/bin/sub.2
	
	for i in $@;do echo -e "qsub -N ${i##*.} $SUB blastall -p blastx -d $DB -i $i -o $i.xml -e 0.000001 -m 7 -a 2\nsleep 10";done 
#for i in $@;do echo -e "qsub -N ${i##*.} $SUB blastall -p blastx -d $DB -i $i -o $i.table -e 0.000001 -m 9 -a 2\nsleep 10";done 

else
	usage "X.split.aa X.split.ab ...."
fi

