#!/bin/sh

#$ -v path
#$ -cwd
#$ -S /bin/bash
#$ -q high.q
#$ -j y
#$ -e TMP
#$ -o TMP
#$ -pe orte 32

##$ -S /bin/sh
##$ -l highprio -pe high 32
##$ -q *@machineName-n*
##$ -pe make 32

source /home/adminrig/.bashrc

TENKG_DIR=/home/adminrig/Genome/1000Genomes/20130502
PLINK_DIR=Plink
THREADS=32
SHAPEIT_DIR=shapeit
SHAPEIT=$TENKG_DIR/shapeit/shapeit

if [ -f "config" ];then
	source $PWD/config
fi

BIM=$PLINK_DIR/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr${SGE_TASK_ID}.bim

if [ -f "$BIM" ];then

	[ ! -d "$SHAPEIT_DIR" ] && mkdir $SHAPEIT_DIR
	
	$SHAPEIT -B ${PLINK_DIR}/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr${SGE_TASK_ID} -M $TENKG_DIR/1000GP_Phase3/1000GP_Phase3/genetic_map_chr${SGE_TASK_ID}_combined_b37.txt --effective-size 14269 --output-max $SHAPEIT_DIR/chr${SGE_TASK_ID}_phased.haps $SHAPEIT_DIR/chr${SGE_TASK_ID}_phased.sample -T $THREADS --output-log $SHAPEIT_DIR/chr${SGE_TASK_ID}_shapeitv2_log  &> $TMP_DIR/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.$HOSTNAME
	 


else
	usage "SGE_TASK_ID"
fi



