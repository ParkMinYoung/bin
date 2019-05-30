#!/bin/sh

source ~/.bash_function


if [ $# -eq 2 ] && [ -f "$1" ] ;then


		if [ ! -f "$1.bai" ];then
			# index bam
			samtools index $1
		fi


		REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
		OUT=$1.$2.bam
		SOUT=$OUT.sort
		samtools view -b -o $OUT $1 $2
		samtools sort $OUT $SOUT
		samtools index $SOUT.bam
		samtools pileup -c -2 -Q 0 -f $REF $SOUT.bam > $SOUT.bam.pileup
		PileupParsing.noTarget.pl --in-file $SOUT.bam.pileup --target-file $SOUT.bam.pileup quality-score 0 --out-file $SOUT.bam.pileup.AlleleCnt

		#samtools pileup -c -2 -Q 20 -f $REF $SOUT.bam > $SOUT.bam.pileup
		##samtools pileup -c -2 -Q 20 -f $REF $SOUT.bam > $SOUT.bam.baseQC20.pileup
		#PileupParsing.noTarget.pl --in-file $SOUT.bam.pileup --target-file $SOUT.bam.pileup quality-score 10 --out-file $SOUT.bam.pileup.AlleleCnt
		DIR=$2
		OUTDIR=${DIR/:/-}
		if [ ! -d "$OUTDIR" ];then
			mkdir $OUTDIR
		fi

		mv $OUT* $OUTDIR

else
	usage "sorted.bam chr3:75713487-75716368"
fi


# sort bam
# samtools sort $1 $1.sort

# samtools view -bo out.bam s_1.bam.NoMQ.sorted.bam chr14:73603142-73690399


