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
    echo "usage : `basename $0` xxx.vcf yyy.vcf ..."
	java $JMEM -jar $EGATK -T CombineVariants --help
	exit 1
fi

for i in $@;
	do 
	if [ -e $i ];then
		IN=$(echo "$IN --variant $i")
	else
		usage "bam file dont exist!"
	fi
done

#L=$2
#INTERVAL=${L:=$SureSelectINTERVAL}
#INTERVAL=$SureSelectINTERVAL

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMAX -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T CombineVariants						\
-R $REF									\
--genotypemergeoption REQUIRE_UNIQUE	\
--filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED				\
$IN                                     \
--assumeIdenticalSamples				\
-o $1.CombineVariants.vcf				\
>& $1.CombineVariants.log

 grep -v "^#" $1.CombineVariants.vcf | cut -f7 | sort | uniq -c | awk '{print $2,"\t",$1}' > $1.CombineVariants.vcf.TypeCount

# -L $INTERVAL 							\
