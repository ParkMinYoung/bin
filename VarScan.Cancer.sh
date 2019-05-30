#!/bin/sh


source ~/.GATKrc


if [ $# -eq 0 ];then
	echo "usage : `basename $0` Normal.bam Cancer.bam"
	echo "$normal_pileup = \"samtools view -b -u -q 1 $normal_bam | samtools pileup -f $reference -\";"
	echo "$tumor_pileup = \"samtools view -b -u -q 1 $tumor_bam | samtools pileup -f $reference -\";"
	java $JMEM -jar $VarScan 
	exit 1
fi

NORMAL=$1
CANCER=$2

NORMAL_PILEUP=$(samtools view -b -u -q 10 $NORMAL | samtools pileup -f $REF_Short -)
CANCER_PILEUP=$(samtools view -b -u -q 10 $CANCER | samtools pileup -f $REF_Short -)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMAX -Djava.io.tmpdir=$TMPDIR -jar $VarScan somatic \
<($NORMAL_PILEUP) \
<($CANCER_PILEUP) \
$NORMAL.VarScan.Somatic.report



