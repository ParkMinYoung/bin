#!/bin/sh

. ~/.bash_function
. ~/.perl

if [ -f "$1" ]; then

REF_DIR=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Arabidopsis_thaliana/Arabidopsis_thaliana/Ensembl/TAIR10/Sequence/Bowtie2Index/
GTF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Arabidopsis_thaliana/Arabidopsis_thaliana/Ensembl/TAIR10/Annotation/Archives/archive-2013-03-06-09-54-25/Genes/genes.gtf
GTFBED=$GTF.bed
REF=$REF_DIR/genome
#perl -F'\t' -anle'print join "\t", @F[0,3,4,1]' $GTF > $GTFBED


DIR=$(dirname $1)
FASTQ=$1.cutadaptTrim.fastq
MAP1_BAM=$DIR/accepted_hits.bam
MAP2_BAM=$DIR/unmapped_remap.bam
MAP3_BAM=$DIR/aligned.bam

cutadapt -m 16 -b GGCCAAGGCG -o $FASTQ $1 > $1.log


## 1st mapping 
STAR.RNA.Arabidopsis.sh $FASTQ 
samtools view -uhS -F4 $FASTQ.starAligned.out.sam | samtools sort - ${MAP1_BAM/%.bam/}

## 2rd mapping 
GetStarUnmappedFasta.sh $FASTQ
bowtie2 --local --very-sensitive-local -p 12 --mm -x $REF -U $FASTQ.unmapped.fastq  | samtools view -uhS -F4 - | samtools sort - ${MAP2_BAM/%.bam/} 


bam2index.flag.sh $MAP1_BAM
bam2index.flag.sh $MAP2_BAM


Merge=/home/adminrig/src/picard/picard-tools-1.76/MergeSamFiles.jar

java -jar $Merge \
        USE_THREADING=true \
        MSD=true \
        AS=true \
        I=$MAP1_BAM \
        I=$MAP2_BAM	\
        O=$MAP3_BAM



cufflinks -p 16 -G $GTF -o $DIR/cufflink $MAP3_BAM
bam2index.flag.sh $MAP3_BAM

#samtools view aligned.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > aligned.fastq
read.len.dist.sh `find -type f | grep fastq$`

mRNA.region.intersect.sh $MAP3_BAM $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

Proton.MappedReads.STAR.sh

## ngs.plots
ID=$(basename $1 | cut -d"_" -f1)
ngs.plot.r -G Tair10 -R genebody -C $MAP3_BAM -O $ID.RNA.genebody -FL 300 -L 3000 -T $ID.RNA.Library

else
	usage "XXX.fastq"

fi

