#!/bin/bash

. ~/.bashrc
. ~/.bash_function

#### PARAM SETTING ####

## AFFY Library Files

COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip

## Date
DATE=$(date +%Y%m%d)


## SCRIPT
AFFY_CHIP_BATCH_SUMMARY_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipBatchSummary.R


if [ -d "$1" ];then

	if [ -f "config" ];then
	# for SGE
	#if [ -f "/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/config" ];then
		source $PWD/config
		# for SGE
		#source /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/config
	fi

	CEL_DIR=$1
	SET_DIR=$(dirname $CEL_DIR)
	SET_NUM=$(basename $SET_DIR)

	## To get CEL file information, 20160928
	SC=/home/adminrig/src/short_read_assembly/bin/GetHeaderFromCel.CreatedDate.pl
	(cd $CEL_DIR && for i in *.CEL; do $SC $i; done > CELFile_information)
	##

	cd $SET_DIR

#DIR=batch-$DATE
#CEL=cel-$DATE.txt
	DIR=batch
	CEL=celfiles.txt

	(echo cel_files; find CEL -type f | grep -i \.CEL$) > $CEL

	# apt-geno : DQC analysis
	# DQC # 0.82
	# for 6.0 array
	#time apt-geno-qc --cdf-file $CDF --qcc-file $QCC --qca-file $QCA --out-file $DIR/apt-geno-qc.txt --cel-files $CEL 
	time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL &

	# apt-probeset-genotype : Genotyping analysis
	# for 6.0 array
	#time apt-probeset-genotype -o $DIR  -c $CDF  -a birdseed-v2  --chrX-probes $X  --chrY-probes $Y  --read-models-birdseed $MODEL --special-snps $SPECIAL --force --set-gender-method cn-probe-chrXY-ratio  --summaries  --cel-files $CEL
	# for Axiom
#!#	time apt-probeset-genotype --xml-file $GENO_XML --analysis-files-path $LIB_DIR --out-dir $DIR --cel-files $CEL --write-models --summaries --force 
	
	time apt-genotype-axiom --analysis-files-path $LIB_DIR --arg-file $GENO_XML --out-dir $DIR --cel-files  $PWD/$CEL --log-file $DIR/apt-genotype-axiom.log --dual-channel-normalization true --snp-posteriors-output --allele-summaries --force

	LIB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_PMRA/Axiom_PMRA.na35.annot.csv.tab
    # get plink output
	Plate2Plink.sh $PWD $LIB


	
	# plot
	/usr/local/bin/R CMD BATCH --no-save --no-restore $AFFY_CHIP_BATCH_SUMMARY_R
	
	# ReName 
	for i in apt-geno.png apt-probeset-genotype.png Summary.png;do mv -f $i $SET_NUM.$i;done

	# copy home dir
	\cp -f *png $COLLECT_HOME

	# 20180621 bymin : insert common foot script
	apt-probeset-genotype.foot.sh



else
	usage "CEL_FILE_DIR[Analysis/000001/CEL]"
fi

