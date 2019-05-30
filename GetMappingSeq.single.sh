#!/bin/sh
source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ $# -ge 3 ];then

FileCheck $@

T=$4
TARGET_BED=${T:=$SureSelectNUMBED}


# READ1=$1
READ1=$(GetSeqFromFastq $1)

# TRIM1=$3
# TRIM2=$4
# SINGLE=$5

SINGLE=$(GetSeqFromFastq $2)

# for i in $READ1 $READ2 $TRIM1 $TRIM2 $SINGLE $(($READ1+$READ2)) $(($TRIM1+$TRIM2+$SINGLE));do echo $i;done > out.txt

READ_SEQ=$READ1
TRIMMED_SEQ=$SINGLE

BAM=$3
TOTAL_BAM=$BAM.Total.genomeCoverage
TARGET_BAM=$BAM.Target.genomeCoverage

genomeCoverage.parsing.sh $BAM $TARGET_BED
TOTAL_SEQ=$(genomeCoverage.GetSeq.sh $TOTAL_BAM)
TARGET_SEQ=$(genomeCoverage.GetSeq.sh $TARGET_BAM)
	
echo "01.READ1	$READ1
02.SINGLE	$SINGLE
03.READ_SEQ	$READ_SEQ
04.TRIMMED_SEQ	$TRIMMED_SEQ
05.TOTAL_SEQ	$TOTAL_SEQ
06.TARGET_SEQ	$TARGET_SEQ"  > $1.seq.summary

echo "04.trimmed	$(($READ_SEQ-$TRIMMED_SEQ))
03.unmapped	$(($TRIMMED_SEQ-$TOTAL_SEQ))
02.offtarget	$(($TOTAL_SEQ-$TARGET_SEQ))
01.ontarget	$TARGET_SEQ"  > $1.mapping.summary

else 
	usage "read.1.fastq{.gz} single xxx.bam [target.bed:SureSelectV2]"
fi

