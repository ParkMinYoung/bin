#!/bin/sh

#$ -v path
#$ -cwd
#$ -S /bin/sh
#$ -pe orte 2  
#$ -S /bin/bash
#$ -q high.q
#$ -j y


source /home/adminrig/.bashrc


TENKG_DIR=/home/adminrig/Genome/1000Genomes/20130502
SHAPEIT_DIR=shapeit
IMPUTE_DIR=imputation

IMPUTE2=$TENKG_DIR/impute/impute_v2.3.2_x86_64_static/impute2
REF_DIR=$TENKG_DIR/1000GP_Phase3/1000GP_Phase3


if [ -f "config" ];then
	source $PWD/config
fi


CHR=$1
BED=$2

[ ! -d "$IMPUTE_DIR" ] && mkdir $IMPUTE_DIR

#FILE_ITEM_STR=$(cat $BED)
#FILE_ITEM_ARRAY=( $FILE_ITEM_STR ) 

## Array's index start zero.
## So, to use SGE_TASK_ID number based on file number, must insert element for zero index.

A=(0)
readarray B < $BED
FILE_ITEM_ARRAY=("${A[@]}" "${B[@]}")

LOC=( ${FILE_ITEM_ARRAY[$SGE_TASK_ID]} )

# echo ${FILE_ITEM_ARRAY[*]}
# echo ${#FILE_ITEM_ARRAY[@]}
#echo ${FILE_ITEM_ARRAY[1]}
#LOC=( ${FILE_ITEM_ARRAY[1]} )
#echo ${LOC[*]}

$IMPUTE2 -use_prephased_g -m $REF_DIR/genetic_map_${CHR}_combined_b37.txt -h $REF_DIR/1000GP_Phase3_${CHR}.hap.gz -l $REF_DIR/1000GP_Phase3_${CHR}.legend.gz -known_haps_g $SHAPEIT_DIR/${CHR}_phased.haps -int ${LOC[1]} ${LOC[2]} buffer 1000 Ne 14269 -o_gz -o $IMPUTE_DIR/${LOC[0]}_${LOC[1]}_${LOC[2]} -filt_rules_l "EAS==0" -allow_large_regions &> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME

#echo "$IMPUTE2 -use_prephased_g -m $REF_DIR/genetic_map_${CHR}_combined_b37.txt -h $REF_DIR/1000GP_Phase3_${CHR}.hap.gz -l $REF_DIR/1000GP_Phase3_${CHR}.legend.gz -known_haps_g $SHAPEIT_DIR/${CHR}_phased.haps -int ${LOC[1]} ${LOC[2]} buffer 1000 Ne 14269 -o_gz -o $IMPUTE_DIR/${LOC[0]}_${LOC[1]}_${LOC[2]} -filt_rules_l \"EAS==0\" -allow_large_regions" &> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME


echo $JOB_ID $JOB_NAME $HOSTNAME $SGE_TASK_ID $@ >> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME
