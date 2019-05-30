#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ -f "$1" ] && [ -f "$2" ];then

T=$2
D=$SureSelectNUMBED
Target=${T:=$D}


genomeCoverageBed -ibam $1 -g $REF_GENOME > $1.Total.genomeCoverage

#same
#bamToBed -i $1 | cut -f1-3 | genomeCoverageBed -i stdin -g $REF_GENOME > $1.Total.genomeCoverage

# intersectBed -abam $1 -b $Target -bed | genomeCoverageBed -i stdin -g $REF_GENOME > $1.Target.genomeCoverage

#same
# bamToBed -i $1 | cut -f1-3 | intersectBed -a stdin -b $Target | genomeCoverageBed -i stdin -g $REF_GENOME > $1.Target.genomeCoverage

intersectBed -abam $1 -b $Target -ubam | genomeCoverageBed -ibam stdin -g $REF_GENOME > $1.Target.genomeCoverage

else
	usage "xxxx.bam ~/Genome/RainDance/BMS.Samsung.hg19.chrX/RainDanceHg19.NoChr.bed"
fi


