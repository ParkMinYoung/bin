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
    echo "usage : `basename $0` [chr1..chr22, chrX, chrY,chrM] XXX.bam [... ZZZ.bam]" 
	java $JMEM -jar $EGATK -T DepthOfCoverage --help
	exit 1
fi

CHR=$1
shift


for i in $@;
    do
    if [ -e $i ];then
        IN=$(echo "$IN -I $i")
    else
        usage "bam file dont exist!"
    fi
done

TMPDIR=$(dirname $1)
L=$WGS_SUB_DIR/$CHR.bed

DIR=$(dirname $1)
output=$DIR/WGS.DepthCoverage.subchr

if [ ! -d $output ];then
	mkdir $output
fi

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMAX128 -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T DepthOfCoverage						\
-R $UCSChg19							\
$IN	                                    \
-L $L 		  							\
-dt NONE								\
--minMappingQuality 0					\
--minBaseQuality 0						\
--outputFormat table					\
--omitDepthOutputAtEachBase				\
-o $output/$CHR.DepthOfCoverage.report			\
-ct 1 -ct 5 -ct 10 -ct 15 -ct 20 -ct 25 -ct 30 -ct 35 -ct 40 -ct 45 -ct 50        \
-ct 55 -ct 60 -ct 65 -ct 70 -ct 75 -ct 80 -ct 85 -ct 90 -ct 95 -ct 100      \
>& $output/$CHR.DepthOfCoverage.log

# --printBaseCounts 						\

# use for speedup 
# omit --printBaseCounts
# --omitLocusTable                                                \
# --omitDepthOutputAtEachBase                             \
				

# -I $1									\
# can not use -nt option 
# -nt 4									\
