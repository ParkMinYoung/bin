#!/bin/sh

#$ -v path
#$ -cwd
#$ -S /bin/sh
#$ -pe make 1 
#$ -S /bin/bash
#$ -q high.q
#$ -j y
#$ -e TMP
#$ -o TMP

##$ -l highprio -pe high 32
##$ -pe orte 1
##$ -q *@machineName-n*


source /home/adminrig/.bashrc

#CHECK_DIR=check
#PLINK_DIR=Plink
#THREADS=24

SHAPEIT_DIR=shapeit
IMPUTE_DIR=imputation
TENKG_DIR=/home/adminrig/Genome/1000Genomes/20130502

IMPUTE2=$TENKG_DIR/impute/impute_v2.3.2_x86_64_static/impute2
REF_DIR=$TENKG_DIR/1000GP_Phase3/1000GP_Phase3
BED_DIR=TARGET_BED

BIN=/home/adminrig/src/short_read_assembly/bin
IMPUTE2_SUBSCRIPT=$BIN/impute2.analysis.SGE.sh

if [ -f "config" ];then
	source $PWD/config
fi



#SGE_TASK_ID=22
CHR=chr${SGE_TASK_ID}
CHR_NUM=${SGE_TASK_ID}

BED=$BED_DIR/$CHR.bed

#sleep $(( $CHR_NUM * 3 ))
[ ! -d "$BED_DIR" ] && mkdir $BED_DIR 

genome2bed.sh | grep -v -e chrM -e chrX  -e chrY | grep -w ^$CHR > $BED


# I think that it is difference between SCALAR and ARRAY
# because STR has new line, so convert SCALAR to ARRAY
TASK=$(wc -l $BED)
T=( $TASK )
echo `date` "$JOB_ID $JOB_NAME $HOSTNAME $CHR_NUM $BED"

# to use 
#qsub -q *@cp* -N impute2_${CHR_NUM} -v CHR="$CHR" -e $TMP_DIR/impute2_${CHR_NUM} -o $TMP_DIR/impute2_${CHR_NUM} -t 1-${T[0]} impute2.analysis.SGE.sh $CHR "$BED"
qsub -N impute2_${CHR_NUM} -v CHR="$CHR" -e $TMP_DIR/impute2_${CHR_NUM} -o $TMP_DIR/impute2_${CHR_NUM} -t 1-${T[0]} $IMPUTE2_SUBSCRIPT $CHR "$BED"

#qsub -N test -v CHR="$CHR_NUM" ./date.SGE.sh "test" "test" test
#qsub -N test -v CHR="$CHR_NUM" -e $TMP_DIR/impute2_${CHR_NUM} -o $TMP_DIR/impute2_${CHR_NUM} -t 1-22 ./date.SGE.sh B B B
#qsub -N impute2_${CHR_NUM} -v CHR="$CHR_NUM" -e $TMP_DIR/impute2_${CHR_NUM} -o $TMP_DIR/impute2_${CHR_NUM} -t 1-$TASK ./date.SGE.sh a A a
#qsub -N impute2_${CHR_NUM} -v CHR="$CHR_NUM" BED="$BED" -e $TMP_DIR/impute2_${CHR_NUM} -o $TMP_DIR/impute2_${CHR_NUM} -t 1-$TASK /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.2015.GSK.v3/Analysis/Analysis.9850.20150331/batch/Imputation/impute2.analysis.SGE.sh $CHR_NUM $BED

