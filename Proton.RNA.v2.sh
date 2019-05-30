#!/bin/sh

. ~/.bash_function

if [ $# -eq 2 ] & [ -f "$1" ];then


perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", "$F[0]",@F[1..$#F]' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf.bed > Homo_sapiens.GRCh37.69.gtf.bed

GTF=/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL1-29-20130924-sRNA-test1_82_112/Fastq/genes.gtf
GTFBED=$PWD/Homo_sapiens.GRCh37.69.gtf.bed
REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Homo_sapiens/genome

OUT_DIR="tophat_"$2

cutadapt -m 16 -b GGCCAAGGCG -o $1.cutadaptTrim.fastq $1 > $1.log
tophat -p 12 --keep-fasta-order -o $OUT_DIR --GTF $GTF $REF $1.cutadaptTrim.fastq

# tophat cufflinks
cufflinks -p 16 -G $GTF -o $OUT_DIR/cufflink $OUT_DIR/accepted_hits.bam
bam2index.flag.sh $OUT_DIR/accepted_hits.bam 

mRNA.region.intersect.sh $OUT_DIR/accepted_hits.bam $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

else
	usage "XXX.fastq SampleID"
fi

