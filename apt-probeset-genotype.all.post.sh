#!/bin/sh

. ~/.bashrc
. ~/.bash_function

#### PARAM SETTING ####

## AFFY Library Files
CDF=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.cdf
X=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.chrXprobes
Y=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.chrYprobes
MODEL=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.birdseed-v2.models
SPECIAL=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.specialSNPs
QCC=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.r2.qcc
QCA=/home/adminrig/Genome/APTToolsLibrary/GenomeWideSNP_6.r2.qca


CDF=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.cdf
X=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.chrXprobes
Y=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.chrYprobes
MODEL=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.AxiomGT1.models
SPECIAL=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.specialSNPs
QCC=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.qcc
QCA=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.qca
DQC_XML=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319.r1.apt-geno-qc.AxiomQC1.xml
GENO_XML=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319_96orMore_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
#GENO_XML=/home/adminrig/Genome/APTToolsLibrary/Axiom_Exome319_LessThan96_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
LIB_DIR=/home/adminrig/Genome/APTToolsLibrary
LIB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab

#Axiom_Exome319_96orMore_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_96orMore_Step2.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_LessThan96_Step1.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319_LessThan96_Step2.r1.apt-probeset-genotype.AxiomGT1.xml
#Axiom_Exome319.r1.apt-geno-qc.AxiomQC1.xml


## Date

FINAL_DIR=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.YSUniv.LeeJongHo.v1
COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip/Axiom_KORV1.0.YSUniv.LeeJongHo.v1.N384/

	(cd Output &&  R CMD BATCH --no-save --no-restore  ~/src/short_read_assembly/bin/R/Ps.performance.R)

	/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM ../MARKER AxiomGT1.calls.txt
	/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab 

#	grep -e MonoHighResolution$ -e NoMinorHom$ -e PolyHighResolution$ Output/Ps.performance.txt | cut -f1 | grep -v ^AFFX  > SNPolisherPassSNV
	cut -f1 Output/Ps.performance.txt > SNPolisherPassSNV

    plink --bfile AxiomGT1.calls.txt.extract.plink --maf 0.1 --geno 0.1 --mind 0.1 --hwe 0.001 --min 0.05 --make-bed --out AxiomGT1.calls.txt.extract.plink.IBS.new --noweb
 
    plink --bfile AxiomGT1.calls.txt.extract.plink.IBS.new --genome --out AxiomGT1.calls.txt.extract.plink.IBS --min 0.05 --thin 0.01 --noweb


	R CMD BATCH --no-save --no-restore '--args AxiomGT1.calls.txt.extract.plink.IBS.genome ' ~/src/short_read_assembly/bin/R/IBS.scatterplot3d.final.R

	awk '{print $1"\t"$1}' SNPolisherPassSNV > SNPolisherPassSNV.MARKER
	ln -s AxiomGT1.calls.txt AxiomGT1.calls.SNPolisherPass.txt
	/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM SNPolisherPassSNV.MARKER AxiomGT1.calls.SNPolisherPass.txt
	Num2Geno.Affy.sh $LIB AxiomGT1.calls.SNPolisherPass.txt.extract > Genotype
	
	plink --bfile AxiomGT1.calls.txt.extract.plink_fwd.gender --check-sex --out GenderCheck --noweb

	# convert plink to vcf
	plink2vcf.sh $LIB 

	# copy home dir
	cd $FINAL_DIR 
	AffyChipSummary.sh
	\cp -f `find | grep -e png$ -e xlsx$ -e genome$ -e GenderCheck.sexcheck$` $COLLECT_HOME

	mkdir -p submit/{CEL,Genotype,Plink,Report}
	ln $PWD/*CEL submit/CEL
	ln $PWD/Analysis/Analysis.*/batch/submit/Plink.Affy.zip submit/Plink
	ln $PWD/Analysis/Analysis.*/batch/Genotype submit/Genotype/
