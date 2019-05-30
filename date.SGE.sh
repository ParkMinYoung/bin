
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

source /home/adminrig/.bashrc

TITLE=$1
DETAIL=$2
JOB_ID=$3

shift
shift
shift


echo -e `date`"\t[$TITLE]\t[$DETAIL]\t[$JOB_ID]\t$@"  >> log

