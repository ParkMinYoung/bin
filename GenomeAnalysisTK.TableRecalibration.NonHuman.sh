#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
source ~/.bash_function
GATK_param

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam [ReadGroup] : default VCF:dbDNP132"
	java $JMEM -jar $EGATK -T CountCovariates --help
	exit 1
fi



T=$(date '+%Y%m%d%H%M')

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam XXXX.recal_data.csv ReadGroupId"
	java $JMEM -jar $EGATK -T TableRecalibration --help
	exit 1
fi


#T=$(date '+%Y%m%d%H%M')
#ReadGroup=$3
#RG=${ReadGroup:=$T}

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK      \
-T TableRecalibration       \
-l INFO                     \
-R $REF                     \
-I $1                       \
-recalFile $2		    \
-o $1.TableRecalibration.bam \
--preserve_qscores_less_than 5 \
>& $1.TableRecalibration.log

# omit 
# --default_read_group $RG        \
# --default_platform illumina     \


# cannot use
# -nt 5			    \




