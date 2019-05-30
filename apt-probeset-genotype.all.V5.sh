#!/bin/sh

. ~/.bashrc
. ~/.bash_function

#### PARAM SETTING ####

## AFFY Library Files
CDF=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.Full.cdf
CDF=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.cdf
X=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.chrXprobes
Y=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.chrYprobes
CHRX=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.chrx
MODEL=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.models
MODEL_birdseed=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.v4.5.birdseed.models
SPECIAL=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.specialSNPs
QCC=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.qcc
QCA=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_5.qca



#GENO_XML=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319_LessThan96_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
LIB_DIR=/home/adminrig/Genome/APTToolsLibrary
LIB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab

#Axiom_Exome319_96orMore_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_96orMore_Step2.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_LessThan96_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_LessThan96_Step2.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319.r1.apt-geno-qc.AxiomQC1.xml

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
	    . config
	fi

	CEL_DIR=$1
	SET_DIR=$1
	SET_NUM=$CEL_count.$DATE

#DIR=batch-$DATE
#CEL=cel-$DATE.txt
	ANALYSIS_DIR=Analysis
	DIR=$ANALYSIS_DIR/Analysis.$SET_NUM
	FINAL_DIR=$PWD
	CEL=celfiles.txt

	if [ ! -d $DIR ];then
		mkdir -p $DIR/batch
	fi

	cd $DIR
	(echo cel_files; ls ../../*.CEL ) > $CEL

	#perl -nle'next if /^cel/; s/\.\.\/\.\.\///;  /(A.+(NI.+)\.CEL)/; print "$1\t$2"' $CEL > SAM


	DIR=batch

	# apt-geno : DQC analysis
	# DQC # 0.82
	# for 6.0 array
	time apt-geno-qc --cdf-file $CDF --qcc-file $QCC --qca-file $QCA --out-file $DIR/apt-geno-qc.txt --cel-files $CEL & 
    #time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL & 

	# apt-probeset-genotype : Genotyping analysis
	# for 5.0 array

    ## for brlmm-p
#    apt-probeset-genotype -o $DIR -c $CDF -a brlmm-p --read-models-brlmmp $MODEL --chrX-snps $CHRX --force  --summaries  --cel-files $CEL --write-models -use-disk false --disk-cache 800000 
    apt-probeset-genotype -o $DIR -c $CDF -a brlmm-p --read-models-brlmmp $MODEL --chrX-snps $CHRX --force  --summaries  --cel-files $CEL --write-models 

	## for birdseed-v2
	# apt-probeset-genotype -o $DIR/$CEL -c $CDF -a birdseed-v2 --chrX-probes $X --chrY-probes $Y --read-models-birdseed $MODEL_birdseed --special-snps $SPECIAL --force --set-gender-method cn-probe-chrXY-ratio  --summaries  --cel-files $CEL --write-models



	# for Axiom
    #time apt-probeset-genotype --xml-file $GENO_XML --analysis-files-path $LIB_DIR --out-dir $DIR --cel-files $CEL --write-models --summaries --force 
	
	
	#AffyChipSummary.sh
	/home/adminrig/src/short_read_assembly/bin/AffyChipSummary.txt.V5.sh

else
	usage "CEL_FILE_DIR[/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.BAK]"
fi

 time apt-probeset-genotype -o $DIR  -c $CDF  -a birdseed-v2  --chrX-probes $X  --chrY-probes $Y  --read-models-birdseed $MODEL --special-snps $SPECIAL --force --set-gender-method cn-probe-chrXY-rat    io  --summaries  --cel-files $CEL --use-disk false --disk-cache 800000 --write-models 
 1 

