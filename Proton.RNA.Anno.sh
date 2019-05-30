#!/bin/sh

. ~/.bash_function
. ~/.perl

if [ -f "$1" ];then

DIR=$(dirname $1)

#perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", @F' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf > $DIR/Homo_sapiens.GRCh37.69.gtf
#perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", "$F[0]",@F[1..$#F]' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf.bed > $DIR/Homo_sapiens.GRCh37.69.gtf.bed

GTF=/home/adminrig/Genome/GTF/genes.gtf
GTFBED=$DIR/Homo_sapiens.GRCh37.69.gtf.bed
REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Homo_sapiens/genome

#bam2index.flag.sh $1

mRNA.region.intersect.sh $1 $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

else
    usage "XXX.bam"
fi

