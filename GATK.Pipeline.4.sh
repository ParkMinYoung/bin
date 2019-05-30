#!/bin/sh 


#$1=s_2/s_2.1.fastq
#$2=s_2/s_2.2.fastq
#$3=ReadGroup

source ~/.bash_function
if [ $# -eq 3 ] & [ -f "$1" ] & [ -f "$2" ];then

#dot2N.sh $1 &
#dot2N.sh $2 &

#wait

	TrimmerF10L10.sh $1 & 
	TrimmerF10L10.sh $2 &

	wait
	
	GATK.Pipeline.2.sh $1.trimmerF10L10.gz $2.trimmerF10L10.gz $3

else
	usage "R1.fastq R2.fastq ReadGroup(sample name, id)"
fi

