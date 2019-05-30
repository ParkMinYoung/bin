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
	REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta

	R1=$1
	R2=$2

	R1_trim=${R1/%.gz/}.trimed
	R2_trim=${R2/%.gz/}.trimed
	R1_single=${R1/%.gz/}.single	
	
	# trimming
	Trim.pl --type 2 --qual-type 1 --pair1 $R1 --pair2 $R2 --outpair1 $R1_trim --outpair2 $R2_trim --single $R1_single

	# align
	# -l : seed len
	# -k : mismatch in seed len
	# -t : thread

	# Paired End ==================================================================
		bwa aln -t $T -l $S -k $M $REF $R1_trim > $R1_trim.sai 2> $R1_trim.sai.log
		bwa aln -t $T -l $S -k $M $REF $R2_trim > $R2_trim.sai 2> $R2_trim.sai.log

		bwa sampe $REF $R1_trim.sai $R2_trim.sai $R1_trim $R2_trim | gzip > $R1.PE.sam.gz 2> $R1.PE.sam.gz.log

		# covert SAM to BAM and perform sorting
		samtools view -uS $R1.PE.sam.gz | samtools sort - $R1.PE.sorted

	# Single End ==================================================================
		bwa aln -t $T -l $S -k $M $REF $R1_single > $R1_single.sai 2> $R1_single.sai.log 

		bwa samse $REF $R1_single.sai $R1_single | gzip > $R1.SE.sam.gz 2> $R1.SE.sam.gz.log 

		# covert SAM to BAM and perfrom sorting
		samtools view -uS $R1.SE.sam.gz | samtools sort - $R1.SE.sorted

	# merge
	samtools merge $R1.bam $R1.PE.sorted.bam $R1.SE.sorted.bam

	fi

else
	usage "1.fastq{.gz} 2.fastq{.gz} [thread number 4] [seedlen 32] [mismatch 2]"
fi


~                                                                                                                                                                                             
~                                                                                                                        


