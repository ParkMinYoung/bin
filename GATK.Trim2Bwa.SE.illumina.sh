#!/bin/sh

source ~/.bash_function
GATK_param

if [ $# -ge 1 ];then

	
	if [ -f "$1" ];then
	Thread=$2
	SeedLen=$3
	MisMatch=$4

	T=${Thread:=4}
	S=${SeedLen:=32}
	M=${MisMatch:=2}

	# reference 
	# $REF come from .GATKrc	

	R1=$1

	R1_trim=${R1/%.gz/}.single.fastq
	
 
     Q=20
     L=20

	sickle se -f $R1 -q $Q -t illumina -l $L -o $R1_trim >& $1.sicle.log 
	cutadapt.v2.sh $R1_trim

	R1_single=$R1_trim.cutadapt	

	# align
	# -l : seed len
	# -k : mismatch in seed len
	# -t : thread

	# Single End ==================================================================
		bwa aln -t $T -l $S -k $M $REF $R1_single > $R1_single.sai 2> $R1_single.sai.log 

		bwa samse $REF $R1_single.sai $R1_single | gzip > $R1.SE.sam.gz 2> $R1.SE.sam.gz.log 

		# covert SAM to BAM and perfrom sorting
		samtools view -uS $R1.SE.sam.gz | samtools sort - $R1


	fi

else
	usage "1.fastq{.gz} [thread number 4] [seedlen 32] [mismatch 2]"
fi

