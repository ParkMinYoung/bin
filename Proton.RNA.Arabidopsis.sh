#!/bin/sh

. ~/.bash_function
. ~/.perl

if [ -f "$1" ];then

DIR=$(dirname $1)


REF_DIR=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Arabidopsis_thaliana/Arabidopsis_thaliana/Ensembl/TAIR10/Sequence/Bowtie2Index/
GTF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Arabidopsis_thaliana/Arabidopsis_thaliana/Ensembl/TAIR10/Annotation/Archives/archive-2013-03-06-09-54-25/Genes/genes.gtf
GTFBED=$GTF.bed
REF=$REF_DIR/genome
# perl -F'\t' -anle'print join "\t", @F[0,3,4,1]' $GTF > $GTFBED

cutadapt -m 16 -b GGCCAAGGCG -o $1.cutadaptTrim.fastq $1 > $1.log
tophat -p 12 -o $DIR/tophat_out --keep-fasta-order --GTF $GTF $REF $1.cutadaptTrim.fastq

cd $DIR

# tophat cufflinks
cufflinks -p 16 -G $GTF -o $DIR/tophat_out/cufflink $DIR/tophat_out/accepted_hits.bam
bam2index.flag.sh $DIR/tophat_out/accepted_hits.bam


#bam2fastq -o tophat_out/unmapped.fastq -q tophat_out/unmapped.bam

samtools view $DIR/tophat_out/unmapped.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > $DIR/tophat_out/unmapped.fastq
#!# samtools view tophat_out/accepted_hits.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > tophat_out/accepted_hits.fastq


bowtie2 --local --very-sensitive-local -p 12 --mm -x $REF -U $DIR/tophat_out/unmapped.fastq  | samtools view -uhS -F4 - | samtools sort - $DIR/unmapped_remap
bam2index.flag.sh $DIR/unmapped_remap.bam

#samtools view unmapped_remap.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > unmapped_remap.fastq


Merge=/home/adminrig/src/picard/picard-tools-1.76/MergeSamFiles.jar

java -jar $Merge \
        USE_THREADING=true \
        MSD=true \
        AS=true \
        I=$DIR/tophat_out/accepted_hits.bam \
        I=$DIR/unmapped_remap.bam \
        O=$DIR/aligned.bam



cufflinks -p 16 -G $GTF -o cufflink $DIR/aligned.bam
bam2index.flag.sh $DIR/aligned.bam

#samtools view aligned.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > aligned.fastq
read.len.dist.sh `find -type f | grep fastq$`

mRNA.region.intersect.sh $DIR/aligned.bam $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

Proton.MappedReads.sh 

## ngs.plots
ID=$(basename $1 | cut -d"_" -f1)
ngs.plot.r -G Tair10 -R genebody -C $DIR/aligned.bam -O $ID.RNA.genebody -FL 300 -L 3000 -T $ID.RNA.Library

else
	usage "XXX.fastq"
fi

