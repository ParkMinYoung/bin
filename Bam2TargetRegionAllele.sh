

#!/bin/sh 

# vcf2Region.sh s_4.bam.sorted.bam.bcf.var.raw.vcf.gz

source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ] && [ -f "$2" ];then

	PileupParsing.pl --in-file $1 --target-file $2 --quality-score 20 --out-file $1.AlleleCnt >& $1.log 
	#PileupParsing.pl --in-file s_1.bam.sorted.bam.pileup --target-file s_4.bam.sorted.bam.bcf.var.raw.vcf.gz.bed --quality-score 20 --out-file s_1.bam.sorted.bam.pileup.AlleleCnt

else
	usage "XXX.pileup region.bed"
fi


