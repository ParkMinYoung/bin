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

## 1st mapping 
STAR.RNA.Arabidopsis.sh $1 
samtools view -uhS -F4 $1.starAligned.out.sam | samtools sort - $DIR/accepted_hits


## 2rd mapping 
GetStarUnmappedFasta.sh $1
bowtie2 --local --very-sensitive-local -p 12 --mm -x $REF -U $1.unmapped.fastq  | samtools view -uhS -F4 - | samtools sort - $DIR/unmapped_remap


bam2index.flag.sh $DIR/accepted_hits.bam
bam2index.flag.sh $DIR/unmapped_remap.bam


Merge=/home/adminrig/src/picard/picard-tools-1.76/MergeSamFiles.jar

java -jar $Merge \
        USE_THREADING=true \
        MSD=true \
        AS=true \
        I=$DIR/accepted_hits.bam \
        I=$DIR/unmapped_remap.bam \
        O=aligned.bam



cufflinks -p 16 -G $GTF -o cufflink $DIR/aligned.bam
bam2index.flag.sh $DIR/aligned.bam

#samtools view aligned.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > aligned.fastq
read.len.dist.sh `find -type f | grep fastq$`

mRNA.region.intersect.sh $DIR/aligned.bam $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

Proton.MappedReads.sh

## ngs.plots
ID=$(basename DEX_AAAAAA_L001_R1_001.fastq | cut -d"_" -f1)
ngs.plot.r -G Tair10 -R genebody -C $DIR/aligned.bam -O $ID.RNA.genebody -FL 300 -L 3000 -T $ID.RNA.Library

else
	usage "XXX.fastq"
fi

