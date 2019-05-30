#!/bin/bash


REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Mus_musculus/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome

Name=$1
Case=$2
Con=$3

#Gensize=2.7e9  #hs
Gensize=1.87e9 #mm
#Gensize=9e7    #ce
#Gensize=1.2e8  #dm

# fastqc
(cd $(dirname $Case) && fastqc.batch.sh $(basename $Case) $(basename $Con) )

if [ $# -eq 3 ]; then


        sickle se -q 20 -f $Case -t sanger -o $Case.trimmed.fastq
        sickle se -q 20 -f $Con -t sanger -o $Con.trimmed.fastq

        bowtie2 -p 12 -x $REF $Case.trimmed.fastq | samtools view -uhS -F4 - | samtools sort - $Case.trimmed.bowtie2 &> $Case.trimmed.bowtie2.log   
        bowtie2 -p 12 -x $REF $Con.trimmed.fastq | samtools view -uhS -F4 - | samtools sort - $Con.trimmed.bowtie2  &> $Con.trimmed.bowtie2.log


        bam2index.flag.sh $Case.trimmed.bowtie2.bam
        bam2index.flag.sh $Con.trimmed.bowtie2.bam

		MarkDuplicates.Mark.sh $Case.trimmed.bowtie2.bam
		MarkDuplicates.Mark.sh $Con.trimmed.bowtie2.bam

		RG_case=$(echo $Case  | perl -nle'/\/?(.+)?_\w{6,7}_L00\d/;print $1')
		RG_con=$(echo $Con  | perl -nle'/\/?(.+)?_\w{6,7}_L00\d/;print $1')

		AddOrReplaceReadGroups.sh $Case.trimmed.bowtie2.bam.Dedupping.Mark.bam $RG_case
		AddOrReplaceReadGroups.sh $Con.trimmed.bowtie2.bam.Dedupping.Mark.bam $RG_con

		GenomeAnalysisTK.DepthOfCoverage.REF.sh $REF.fa $Case.trimmed.bowtie2.bam.Dedupping.Mark.bam.AddRG.bam
		GenomeAnalysisTK.DepthOfCoverage.REF.sh $REF.fa $Con.trimmed.bowtie2.bam.Dedupping.Mark.bam.AddRG.bam

        macs14 -t $Case.trimmed.bowtie2.bam -c $Con.trimmed.bowtie2.bam -f BAM -g $Gensize -n $Name/$Name -m 10,50  -w --call-subpeaks &>  $Case.trimmed.bowtie2.bam.MACS.log

elif [ $# -eq 2 ]; then

#       sickle se -q 20 -f $Case -t sanger -o $Case.trimmed.fastq
        bowtie2 -p 12 -x $REF $Case.trimmed.fastq | samtools view -uhS -F4 - | samtools sort - $Case.trimmed.bowtie2
        bam2index.flag.sh  $Case.trimmed.bowtie2.bam

        macs14 -t $Case.trimmed.bowtie2.bam -f BAM -g $Gensize -n $Name -m 10,50  -w --call-subpeaks

else
         echo "usage : run.sh <baseName> <case> <con>"
fi
