GTFBED=/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL1-29-20130924-sRNA-test1_82_112/Fastq/Homo_sapiens.GRCh37.69.gtf.bed

bam2index.flag.sh $1
mRNA.region.intersect.sh  $1 $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`
