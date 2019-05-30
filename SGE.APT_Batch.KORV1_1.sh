#!/bin/sh

#$ -v path
#$ -cwd
#$ -S /bin/sh
#$ -pe orte 2  
#$ -S /bin/bash
#$ -q high.q
#$ -j y


## setting

source /home/adminrig/.bashrc


FILE=$1

#TMP_DIR=${FILE}_TMP
TMP_DIR=TMP
[ ! -d "$TMP_DIR" ] && mkdir $TMP_DIR


## Get Line
A=(0)
readarray B < $FILE
FILE_ITEM_ARRAY=("${A[@]}" "${B[@]}")
#LOC=( ${FILE_ITEM_ARRAY[$SGE_TASK_ID]} )
LINE=${FILE_ITEM_ARRAY[$SGE_TASK_ID]}



## log 
echo $JOB_ID $JOB_NAME $HOSTNAME $SGE_TASK_ID $@ $LINE >> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME

#####################################################################################################3
## main script start

Config=$2

\cp -f $Config $LINE; 

cd $LINE
celfiles.sh
apt-genotype-axiom.step2.r1.sh celfiles 
#apt-probeset-genotype.step2.r1.sh celfiles 

## main script end
#####################################################################################################3






