#!/bin/sh

. ~/.bash_function
. ~/.perl
. ~/.GATKrc


if [ -f "$1" ];then

DIR=$(dirname $1)


## YEAST
#		YEAST_BOWTIE2_REF_DIR=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Saccharomyces_cerevisiae/Ensembl/EF4/Sequence/Bowtie2Index/genome.fa
#		YEAST_BOWTIE2_GTF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Saccharomyces_cerevisiae/Ensembl/EF4/Annotation/Archives/archive-2013-03-06-20-13-33/Genes/genes.gtf
#		YEAST_BOWTIE2_GTFBED=$YEAST_BOWTIE2_GTF.bed
#		YEAST_BOWTIE2_REF=$YEAST_BOWTIE2_REF_DIR/genome
#		YEAST_BOWTIE2_REF_FA=$YEAST_BOWTIE2_REF.fa


REF_DIR=$YEAST_BOWTIE2_REF_DIR
GTF=$YEAST_BOWTIE2_GTF
GTFBED=$YEAST_BOWTIE2_GTFBED
REF=$YEAST_BOWTIE2_REF
REF_FA=$YEAST_BOWTIE2_REF_FA

if [ ! -f "$GTFBED" ];then
	perl -F'\t' -anle'print join "\t", @F[0,3,4,1]' $GTF > $GTFBED
fi


CUTADAPT=$1.cutadaptTrim.fastq

TOPHAT_OUT=$DIR/tophat_out
CUFFLINK_OUT=$TOPHAT_OUT/cufflink

MAP1_BAM=$TOPHAT_OUT/accepted_hits.bam
MAP2_BAM=$DIR/unmapped_remap.bam
MAP3_BAM=$DIR/aligned.bam

fastqc.batch.sh $1

cutadapt -m 16 -b GGCCAAGGCG -o $CUTADAPT $1 > $1.log
tophat -p 12 -o $TOPHAT_OUT --keep-fasta-order --GTF $GTF $REF $CUTADAPT

# tophat cufflinks
cufflinks -p 16 -G $GTF -o $CUFFLINK_OUT $MAP1_BAM
bam2index.flag.sh $MAP1_BAM 


#bam2fastq -o tophat_out/unmapped.fastq -q tophat_out/unmapped.bam

samtools view $TOPHAT_OUT/unmapped.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > $TOPHAT_OUT/unmapped.fastq
#!# samtools view tophat_out/accepted_hits.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > tophat_out/accepted_hits.fastq


bowtie2 --local --very-sensitive-local -p 12 --mm -x $REF -U $TOPHAT_OUT/unmapped.fastq  | samtools view -uhS -F4 - | samtools sort - ${MAP2_BAM/%.bam/}
bam2index.flag.sh $MAP2_BAM

#samtools view unmapped_remap.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > unmapped_remap.fastq


Merge=/home/adminrig/src/picard/picard-tools-1.76/MergeSamFiles.jar

java -jar $Merge \
        USE_THREADING=true \
        MSD=true \
        AS=true \
        I=$MAP1_BAM \
        I=$MAP2_BAM \
        O=$MAP3_BAM



cufflinks -p 16 -G $GTF -o $DIR/cufflink $MAP3_BAM
bam2index.flag.sh $MAP3_BAM

#samtools view aligned.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > aligned.fastq
	CWD=$PWD
	cd $DIR
	read.len.dist.sh `find -type f | grep fastq$` 
	Proton.MappedReads.sh

	mRNA.region.intersect.sh $(basename $MAP3_BAM) $GTFBED
	mRNA.region.count.sh `find -type f | grep miRNA$`
	cd $CWD

ID=$DIR/$(basename $1 | cut -d"_" -f1)
ngs.plot.r -G sacCer3 -R genebody -C $MAP3_BAM -O $ID.RNA.genebody -FL 300 -L 3000 -T $ID.RNA.Library

ln $MAP3_BAM $ID.bam
ln $MAP3_BAM.bai $ID.bam.bai


else
	usage "XXX.fastq"
fi

