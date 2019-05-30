#!/bin/sh

# vcf2table.py.sh
# $1 must be [XXX.vcf]
# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.vcf "
	exit 1
fi

$PYTHON $GATK_PYTHON/vcf2table.py -f CHROM,POS,ID,AC,AF,AN,DB,DP,HRun,MQ,MQ0,HaplotypeScore,QD,SB $1 > $1.table

