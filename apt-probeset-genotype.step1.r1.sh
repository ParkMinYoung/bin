#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

LIB_DIR=/home/adminrig/workspace.min/AFFX/untested_library_files
GENO_XML=$LIB_DIR/Axiom_KORV1_0_96orMore_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
DQC_XML=$LIB_DIR/Axiom_KORV1_0.r1.apt-geno-qc.AxiomQC1.xml

#DIR=APT.step1.r1
DIR=Analysis
mkdir -p $DIR
CEL=$1

time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL
time apt-probeset-genotype --xml-file $GENO_XML --analysis-files-path $LIB_DIR --out-dir $DIR --cel-files $CEL --write-models --summaries --force

AffyChipSummary.txt.sh

else
	usage "celfiles"
fi

