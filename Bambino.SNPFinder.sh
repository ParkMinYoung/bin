#!/bin/sh

. ~/.BAMBINOrc


if [ $# -eq 0 ]; then
	
	java $MEM -jar $BUNDLE Ace2.SAMStreamingSNPFinder
	usage "Normal.bam Tumor.bam"

elif [ $# -ge 2 ];then
	
	$(java $MEM -cp $BUNDLE Ace2.SAMStreamingSNPFinder -limit 1000000 -bam $1 -tn N -bam $2 -tn T -fasta $REF_Short -dbsnp-file $BLOB -of $1.Bambino.report -min-quality 20 -min-mapq 20 -min-coverage 10 -min-minor-frequency 0.15 -min-alt-allele-count 5 -min-unique-alt-reads 5 >& $1.Bambino.report.log)
fi



# 	-min-quality 20[10]
#	-min-mapq 20[0]
#	-min-coverage 10[4]
#	-min-minor-frequency 0.15[0.15] for DNA, but 0.01~0.05 for RNA
#	-min-alt-allele-count 5[3]
#	-min-unique-alt-reads 5[1]
#	


