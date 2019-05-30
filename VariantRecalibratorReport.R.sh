#!/bin/sh

# vcf2table.py.sh
# $1 must be [XXX.vcf]
# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` output.dir XXXX.clusters YYYY.table [loci]"
	exit 1
fi

$R $GATK_R/VariantRecalibratorReport/VariantRecalibratorReport.R \
$1 \
$2 \
$3 \
$4 \

