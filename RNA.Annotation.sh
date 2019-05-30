. ~/.perl

GTFBED=/home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.chr.gtf.bed
#/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL1-29-20130924-sRNA-test1_82_112/Fastq/genes.gtf
#/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Homo_sapiens/genome


mRNA.region.intersect.sh $1 $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`


ID=$(basename $1 .bam)
ngs.plot.r -G hg19 -R genebody -C $1 -O $ID.RNA.tss -FL 300 -L 3000 -T $ID.RNA.Library

