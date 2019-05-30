#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             
#
source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam [YYYY.intervals]"
	java $JMEM -jar $EGATK -T RealignerTargetCreator --help
	exit 1
fi

L=$2
INTERVAL=${L:=$SureSelectINTERVAL}

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T RealignerTargetCreator				\
-R $REF									\
-o $1.RealignerTargetCreator.intervals	\
-I $1									\
--minReadsAtLocus 10 					\
--windowSize 10 						\
--mismatchFraction 0.15         		\
--maxIntervalSize 500           		\
>& $1.RealignerTargetCreator.log

# -B:snps,VCF $VCF						\
# -B:indel,VCF $INDELVCF					\
# -L $INTERVAL							\



##### does not support nt option


#[-L intervals] \
#[-B:snps,VCF /path/to/SNP_calls.vcf] \
#[-B:indels,VCF /path/to/indel_calls.vcf] \
#[-D /path/to/dbsnp.rod]

# --minReadsAtLocus 10			\	# minimum coverage reads default=4
# --windowSize 10				\ 	# two snp calls allowed
# --mismatchFraction f [fraction of total sum of base qualities at a position that need to mismatch for the position to be considered to have high entropy; default=0.15; to disable, set to <= 0 or > 1]
# Note that this fraction should be adjusted based on your particular data set. For deep coverage and/or when looking for indels with low allele frequency, this number should be smaller.
# --maxIntervalSize [max size in bp of intervals that we'll pass to the realigner; default=500]
# Because the realignment algorithm is N^2, allowing too large an interval might take too long to completely realign.




## Emits intervals for the Local Indel Realigner to target for cleaning.  Ignores 454 and MQ0 reads.
