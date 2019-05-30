#!/bin/sh

source ~/.bash_function

if [ $# -ge 2 ];then

	
	if [ -f "$1" ] && [ -f "$2" ];then
	Thread=$3
	SeedLen=$4
	MisMatch=$5

	T=${Thread:=4}
	S=${SeedLen:=32}
	M=${MisMatch:=2}

	# reference 
	REF=/home/adminrig/Genome/Pig/susScr2.fa
	
	R1=$1
	R2=$2

	R1_trim=${R1/%.gz/}.trimed
	R2_trim=${R2/%.gz/}.trimed
	R1_single=${R1/%.gz/}.single	
	
	# trimming
	# sanger type(hiseq CASAVA 1.8)
	# Trim.pl --type 2 --qual-type 0 --pair1 $R1 --pair2 $R2 --outpair1 $R1_trim --outpair2 $R2_trim --single $R1_single
	# illumina 
	#Trim.pl --type 2 --qual-type 1 --pair1 $R1 --pair2 $R2 --outpair1 $R1_trim --outpair2 $R2_trim --single $R1_single

      Q=20
      L=1
 
	# sanger type(hiseq CASAVA 1.8)
    sickle pe -f $R1 -r $R2 -q $Q -t sanger -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
	# illumina 
	# sickle pe -f $R1 -r $R2 -q $Q -t illumina -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log



	# align
	# -l : seed len
	# -k : mismatch in seed len
	# -t : thread

	# Paired End ==================================================================
		# original
		bwa aln -t $T -l $S -k $M $REF $R1_trim > $R1_trim.sai 2> $R1_trim.sai.log
		bwa aln -t $T -l $S -k $M $REF $R2_trim > $R2_trim.sai 2> $R2_trim.sai.log

		# bwa sampe $REF $R1_trim.sai $R2_trim.sai $R1_trim $R2_trim | gzip > $R1.PE.sam.gz 2> $R1.PE.sam.gz.log
		bwa sampe -a 6000 $REF $R1_trim.sai $R2_trim.sai $R1_trim $R2_trim | gzip > $R1.PE.sam.gz 2> $R1.PE.sam.gz.log

		# covert SAM to BAM and perform sorting
		samtools view -uS $R1.PE.sam.gz | samtools sort - $R1.PE.sorted
		
		# estimation of insert size 
		CollectInsertSizeMetrics.sh $R1.PE.sorted.bam
	fi

else
	usage "1.fastq{.gz} 2.fastq{.gz} [thread number 4] [seedlen 32] [mismatch 2]"
fi



