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
PLINK_DIR=Plink

if [ -f "config" ];then
	. config
fi

if [ $# -eq 1 ];then
	PLINK=$1
	[ ! -d "$PLINK_DIR" ] && mkdir $PLINK_DIR
	[ ! -d "$TMP_DIR" ] && mkdir $TMP_DIR

	## use --geno 0.9(To Get Marker equal than CR 90%, if not get error in shapeit step because fully missing SNP)
	plink --bfile $PLINK --chr $SGE_TASK_ID --geno 0.9 --make-bed --out $PLINK_DIR/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr$SGE_TASK_ID --noweb &> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME

else
	usage "PLINK"
fi


