DIR=$(dirname $1)
REF=$2

bedtools=/home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools



$bedtools bamtobed -i $1 |  bedtools sort -i stdin | bedtools merge -i stdin > $DIR/bam2bed
$bedtools getfasta -fi $REF -bed $DIR/bam2bed -fo $DIR/bam2bed.fasta
faCount $DIR/bam2bed.fasta > $DIR/bam2bed.fasta.NTCount


