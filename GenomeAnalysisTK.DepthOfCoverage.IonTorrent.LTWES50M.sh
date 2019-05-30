#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
source ~/.bash_function
GATK_param

EGATK=/home/adminrig/src/GATK/GenomeAnalysisTK-1.2-60-g585a45b/$GATK


if [ $# -eq 0 ];then
    echo "usage : `basename $0` XXXX.bam yyyy.bam zzz.bam ..."
	java $JMEM -jar $EGATK -T DepthOfCoverage --help
	exit 1
fi

for i in $@;
	do 
	if [ -e $i ];then
		IN=$(echo "$IN -I $i")
	else
		usage "bam file dont exist!"
	fi
done

#L=$2
#INTERVAL=${L:=$SureSelectINTERVAL}
INTERVAL=$LT_WES_50M_INTERVAL

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMAX128 -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T DepthOfCoverage						\
-R $IonHG19								\
$IN                                     \
-dt NONE								\
--minMappingQuality 0					\
-L $INTERVAL							\
--minBaseQuality 0						\
--outputFormat table					\
--omitDepthOutputAtEachBase				\
-o $1.DepthCoverage.Report			\
-ct 1 -ct 5 -ct 10 -ct 15 -ct 20 -ct 25 -ct 30 -ct 35 -ct 40 -ct 45 -ct 50        \
-ct 55 -ct 60 -ct 65 -ct 70 -ct 75 -ct 80 -ct 85 -ct 90 -ct 95 -ct 100      \
>& $1.DepthOfCoverage.log

# --printBaseCounts 						\

# use for speedup 
# omit --printBaseCounts
# --omitLocusTable                                                \
# --omitDepthOutputAtEachBase                             \
				

# -I $1									\
# can not use -nt option 
# -nt 4									\
