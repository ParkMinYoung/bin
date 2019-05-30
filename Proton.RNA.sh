#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

DIR=$(dirname $1)

perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", @F' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf > $DIR/Homo_sapiens.GRCh37.69.gtf
perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", "$F[0]",@F[1..$#F]' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf.bed > $DIR/Homo_sapiens.GRCh37.69.gtf.bed

fastqc.batch.sh $1
GetQualityScoreDist.sh $1 &

GTF=/home/adminrig/Genome/GTF/genes.gtf
GTFBED=$DIR/Homo_sapiens.GRCh37.69.gtf.bed
REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Homo_sapiens/genome

cutadapt -m 16 -b GGCCAAGGCG -o $1.cutadaptTrim.fastq $1 > $1.log
tophat -p 12 -o $DIR/tophat_out --keep-fasta-order --GTF $GTF $REF $1.cutadaptTrim.fastq

cd $DIR

# tophat cufflinks
cufflinks -p 16 -G $GTF -o ./tophat_out/cufflink ./tophat_out/accepted_hits.bam
bam2index.flag.sh ./tophat_out/accepted_hits.bam


#bam2fastq -o tophat_out/unmapped.fastq -q tophat_out/unmapped.bam

samtools view tophat_out/unmapped.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > tophat_out/unmapped.fastq
#!# samtools view tophat_out/accepted_hits.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > tophat_out/accepted_hits.fastq


bowtie2 --local --very-sensitive-local -p 12 --mm -x $REF -U tophat_out/unmapped.fastq  | samtools view -uhS -F4 - | samtools sort - unmapped_remap
bam2index.flag.sh unmapped_remap.bam

#samtools view unmapped_remap.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > unmapped_remap.fastq


Merge=/home/adminrig/src/picard/picard-tools-1.76/MergeSamFiles.jar

java -jar $Merge \
        USE_THREADING=true \
        MSD=true \
        AS=true \
        I=tophat_out/accepted_hits.bam \
        I=unmapped_remap.bam \
        O=aligned.bam



cufflinks -p 16 -G $GTF -o cufflink aligned.bam
bam2index.flag.sh aligned.bam

#samtools view aligned.bam | perl -F'\t' -anle'print join "\n", "\@$F[0]",$F[9],"+",$F[10]' > aligned.fastq
read.len.dist.sh `find -type f | grep fastq$`

mRNA.region.intersect.sh aligned.bam $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`

Proton.MappedReads.sh 

else
	usage "XXX.fastq"
fi

