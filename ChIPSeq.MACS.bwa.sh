#!/bin/bash

. ~/.GATKrc

REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Mus_musculus/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome.fa

Name=$1
Case=$2
Con=$3

#Gensize=2.7e9  #hs
Gensize=1.87e9 #mm
#Gensize=9e7    #ce
#Gensize=1.2e8  #dm

# fastqc
DIR=$(dirname $Case)
(cd $DIR && fastqc.batch.sh $(basename $Case) $(basename $Con) )

if [ $# -eq 3 ]; then


        sickle se -q 20 -f $Case -t sanger -o $Case.trimmed.fastq
        sickle se -q 20 -f $Con -t sanger -o $Con.trimmed.fastq


		# Single End ==================================================================
        bwa aln -t 8 -l 32 -k 2 $REF $Case.trimmed.fastq >  $Case.trimmed.fastq.sai 2>  $Case.trimmed.fastq.sai.log
        bwa samse $REF  $Case.trimmed.fastq.sai  $Case.trimmed.fastq | gzip >  $Case.trimmed.fastq.SE.sam.gz 2>  $Case.trimmed.fastq.SE.sam.gz.log

        # covert SAM to BAM and perfrom sorting
        samtools view -uS  $Case.trimmed.fastq.SE.sam.gz | samtools sort - -T $$.Case -o $Case.trimmed.fastq

		# Single End ==================================================================
        bwa aln -t 8 -l 32 -k 2 $REF $Con.trimmed.fastq >  $Con.trimmed.fastq.sai 2>  $Con.trimmed.fastq.sai.log
        bwa samse $REF  $Con.trimmed.fastq.sai  $Con.trimmed.fastq | gzip >  $Con.trimmed.fastq.SE.sam.gz 2>  $Con.trimmed.fastq.SE.sam.gz.log

        # covert SAM to BAM and perfrom sorting
        samtools view -uS  $Con.trimmed.fastq.SE.sam.gz | samtools sort - -T $$.Con -o $Con.trimmed.fastq

        bam2index.flag.sh $Case.trimmed.fastq.bam
        bam2index.flag.sh $Con.trimmed.fastq.bam

		MarkDuplicates.Mark.sh $Case.trimmed.fastq.bam
		MarkDuplicates.Mark.sh $Con.trimmed.fastq.bam

		RG_case=$(echo $Case  | perl -nle'/\/?(.+)?_\w{6,7}_L00\d/;print $1')
		RG_con=$(echo $Con  | perl -nle'/\/?(.+)?_\w{6,7}_L00\d/;print $1')

		AddOrReplaceReadGroups.sh $Case.trimmed.fastq.bam.Dedupping.Mark.bam $RG_case
		AddOrReplaceReadGroups.sh $Con.trimmed.fastq.bam.Dedupping.Mark.bam $RG_con

		GenomeAnalysisTK.DepthOfCoverage.REF.sh $REF $Case.trimmed.fastq.bam.Dedupping.Mark.bam.AddRG.bam
		GenomeAnalysisTK.DepthOfCoverage.REF.sh $REF $Con.trimmed.fastq.bam.Dedupping.Mark.bam.AddRG.bam

		cd $DIR
        macs14 -t $(basename $Case.trimmed.fastq.bam.Dedupping.Mark.bam.AddRG.bam) -c $(basename $Con.trimmed.fastq.bam.Dedupping.Mark.bam.AddRG.bam) -m 1 --nomodel --shiftsize 100 -f BAM -g $Gensize -n $Name -m 10,30  -w --call-subpeaks &>  MACS.log

elif [ $# -eq 2 ]; then

#       sickle se -q 20 -f $Case -t sanger -o $Case.trimmed.fastq
        bowtie2 -p 12 -x $REF $Case.trimmed.fastq | samtools view -uhS -F4 - | samtools sort - $Case.trimmed.bowtie2
        bam2index.flag.sh  $Case.trimmed.bowtie2.bam

        macs14 -t $Case.trimmed.bowtie2.bam -f BAM -g $Gensize -n $Name -m 10,50  -w --call-subpeaks
		java -jar $ESNPEFF eff -i bed -config $ESNPEFF_CONFIG GRCh37.72 ${Name}_peaks.bed > ${Name}_peaks.bed.SNPEFF

		BaseReadSummary.sh $Case $Case.trimmed.fastq.bam.Dedupping.Mark.bam.flagstats

else
         echo "usage : run.sh <baseName> <case> <con>"
fi
