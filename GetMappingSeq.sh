#!/bin/sh
source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ $# -ge 6 ];then

FileCheck $@

T=$7
TARGET_BED=${T:=$SureSelectNUMBED}


# READ1=$1
READ1=$(GetSeqFromFastq $1)
# READ2=$2
READ2=$(GetSeqFromFastq $2)

# TRIM1=$3
# TRIM2=$4
# SINGLE=$5

TRIM1=$(GetSeqFromFastq $3)
TRIM2=$(GetSeqFromFastq $4)
SINGLE=$(GetSeqFromFastq $5)

# for i in $READ1 $READ2 $TRIM1 $TRIM2 $SINGLE $(($READ1+$READ2)) $(($TRIM1+$TRIM2+$SINGLE));do echo $i;done > out.txt

READ_SEQ=$(($READ1+$READ2))
TRIMMED_SEQ=$(($TRIM1+$TRIM2+$SINGLE))

BAM=$6
TOTAL_BAM=$BAM.Total.genomeCoverage
TARGET_BAM=$BAM.Target.genomeCoverage

genomeCoverage.parsing.sh $BAM $TARGET_BED
TOTAL_SEQ=$(genomeCoverage.GetSeq.sh $TOTAL_BAM)
TARGET_SEQ=$(genomeCoverage.GetSeq.sh $TARGET_BAM)
	
echo "01.READ1	$READ1
02.READ2	$READ2
03.TRIM1	$TRIM1
04.TRIM2	$TRIM2
05.SINGLE	$SINGLE
06.READ_SEQ	$READ_SEQ
07.TRIMMED_SEQ	$TRIMMED_SEQ
08.MAPPED_SEQ	$TOTAL_SEQ
09.TARGET_SEQ	$TARGET_SEQ"  > $1.seq.summary

echo "04.trimmed	$(($READ_SEQ-$TRIMMED_SEQ))
03.unmapped	$(($TRIMMED_SEQ-$TOTAL_SEQ))
02.offtarget	$(($TOTAL_SEQ-$TARGET_SEQ))
01.ontarget	$TARGET_SEQ"  > $1.mapping.summary

else 
	usage "read.1.fastq{.gz} read.2.fastq{.gz} trim.1 trim.2 single xxx.bam [target.bed:SureSelectV2]"
fi

## qsub -N GetMap /home/adminrig/src/short_read_assembly/bin/sub /home/adminrig/src/short_read_assembly/bin/GetMappingSeq.sh 
## ./101N/101N_ATCACG_L001_R1_001.fastq.gz.N.fastq.gz 
## ./101N/101N_ATCACG_L001_R2_001.fastq.gz.N.fastq.single 
## ./101N/101N_ATCACG_L001_R2_001.fastq.gz.N.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam 
## ./101N/101N_ATCACG_L001_R2_001.fastq.gz.N.fastq.trimed 
## ./101N/101N_ATCACG_L001_R2_001.fastq.gz.N.fastq.gz 
## ./101N/101N_ATCACG_L001_R1_001.fastq.gz.N.fastq.trimed
## 
