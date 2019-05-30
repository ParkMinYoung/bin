#!/bin/bash

. ~/.bashrc
. ~/.bash_function

#### PARAM SETTING ####

COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip

## create allele information
# PlinkAlleleUpdate4VCFfrom.sh $KORV1L


## Date
DATE=$(date +%Y%m%d)
CEL_count=$(ls *.CEL | wc -l)


## SCRIPT
AFFY_CHIP_BATCH_SUMMARY_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipBatchSummary.R
SNPolisher=/home/adminrig/src/short_read_assembly/bin/R/SNPolisher.R

if [ -d "$1" ];then

	if [ -f "config" ];then
	    source $PWD/config
	fi

	CEL_DIR=$1
	SET_DIR=$1
	SET_NUM=$CEL_count.$DATE

#DIR=batch-$DATE
#CEL=cel-$DATE.txt
	DIR=$ANALYSIS_DIR/Analysis.$SET_NUM
	FINAL_DIR=$PWD
	CEL=celfiles.txt


	if [ ! -d $DIR ];then
		mkdir -p $DIR/batch
	fi

	cd $DIR
	(echo cel_files; ls ../../*.CEL ) > $CEL

	MakeSAM.sh $CEL > SAM

	awk '{print $1"\t"$1}' $LIB > MARKER


	DIR=batch

	# apt-geno : DQC analysis
	# DQC # 0.82
	# for 6.0 array
	#time apt-geno-qc --cdf-file $CDF --qcc-file $QCC --qca-file $QCA --out-file $DIR/apt-geno-qc.txt --cel-files $CEL 
	time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL 

	# apt-probeset-genotype : Genotyping analysis
	# for 6.0 array
	#time apt-probeset-genotype -o $DIR  -c $CDF  -a birdseed-v2  --chrX-probes $X  --chrY-probes $Y  --read-models-birdseed $MODEL --special-snps $SPECIAL --force --set-gender-method cn-probe-chrXY-ratio  --summaries  --cel-files $CEL
	# for Axiom
#!# time apt-probeset-genotype --xml-file $GENO_XML --analysis-files-path $LIB_DIR --out-dir $DIR --cel-files $CEL --write-models --summaries --force 
	time apt-genotype-axiom --analysis-files-path $LIB_DIR --arg-file $GENO_XML --out-dir $DIR --cel-files  $PWD/$CEL --log-file $DIR/apt-genotype-axiom.log --dual-channel-normalization true --snp-posteriors-output --allele-summaries --force
 
	
	
	# plot
	R CMD BATCH --no-save --no-restore $AFFY_CHIP_BATCH_SUMMARY_R
	
	# ReName 
	for i in *png;do mv $i $SET_NUM.$i;done

	COLLECT_HOME=$COLLECT_HOME
	if [ ! -d $COLLECT_HOME ];then
		mkdir -p $COLLECT_HOME
	fi


	cd $DIR

	ssh -q -x 211.174.205.93 "cd $PWD && batch.SGE.93.sh SNPolisher.sh | sh"

#	R CMD BATCH --no-save --no-restore $SNPolisher
#	(cd Output &&  R CMD BATCH --no-save --no-restore  ~/src/short_read_assembly/bin/R/Ps.performance.R)

	/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM ../MARKER AxiomGT1.calls.txt



	/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract $LIB 

	#!#grep -e MonoHighResolution$ -e NoMinorHom$ -e PolyHighResolution$ Output/Ps.performance.txt | cut -f1 | grep -v ^AFFX  > SNPolisherPassSNV
	cut -f1 Output/Ps.performance.txt  > SNPolisherPassSNV
#plink --bfile AxiomGT1.calls.txt.extract.plink --extract SNPolisherPassSNV --genome --maf 0.4 --geno 0.1 --mind 0.1 --hwe 0.001 --min 0.05 --out AxiomGT1.calls.txt.extract.plink.IBS --noweb
	plink --bfile AxiomGT1.calls.txt.extract.plink --maf 0.1 --geno 0.1 --hwe 0.001 --make-bed --out AxiomGT1.calls.txt.extract.plink.IBS.new --noweb

	/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile AxiomGT1.calls.txt.extract.plink.IBS.new --genome --out AxiomGT1.calls.txt.extract.plink.IBS --min 0.05 --thin 0.01 --allow-no-sex --threads 20
	/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile AxiomGT1.calls.txt.extract.plink.IBS.new --genome --genome-full --out AxiomGT1.calls.txt.extract.plink.IBS_full --allow-no-sex --threads 20

	R CMD BATCH --no-save --no-restore '--args AxiomGT1.calls.txt.extract.plink.IBS.genome ' ~/src/short_read_assembly/bin/R/IBS.scatterplot3d.final.R

	awk '{print $1"\t"$1}' SNPolisherPassSNV > SNPolisherPassSNV.MARKER
	ln -s AxiomGT1.calls.txt AxiomGT1.calls.SNPolisherPass.txt
	/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM SNPolisherPassSNV.MARKER AxiomGT1.calls.SNPolisherPass.txt
	Num2Geno.Affy.sh $LIB AxiomGT1.calls.txt.extract > Genotype
    AddExtraColumn.sh Genotype $KORV1L 1 "3,5,6,7,8,10,14,15"	

	plink --bfile AxiomGT1.calls.txt.extract.plink_fwd.gender --check-sex --out GenderCheck --noweb

	# convert plink to vcf
	plink2vcf.sh $LIB

	# copy home dir
	cd $FINAL_DIR 
	AffyChipSummary.sh
	\cp -f `find | grep -e png$ -e xlsx$ -e genome$ -e GenderCheck.sexcheck$` $COLLECT_HOME
	
	# Signal Cluster Formatting
	perl `which apt-probeset-genotype.PrepareFormatForClusterPlot.pl` --call AxiomGT1.calls.txt --summary AxiomGT1.summary.txt --sample ../SAM --marker ../MARKER
	#perl `which apt-probeset-genotype.CreateClusterPlot.pl` SignalCluster.txt

	mkdir -p submit/{CEL,Genotype,Plink,Report}
	ln $PWD/*CEL submit/CEL
	ln $PWD/Analysis/Analysis.*/batch/submit/Plink.Affy.zip submit/Plink
	ln $PWD/Analysis/Analysis.*/batch/Genotype submit/Genotype/

else
	usage "CEL_FILE_DIR[/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.BAK]"
fi

