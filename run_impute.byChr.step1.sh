#!/bin/bash

.  ~/.bash_function


if [ -f "$1" ] & [ -f "$2" ] ;then

UniqMarker=$1

## check bim file
## must check redundant genotype and site
## if not check, get the error shapeit step


## configure
TREAD=70
BATCH=$PWD
ROOT_DIR=$PWD
WD=$ROOT_DIR
DIR=/home/adminrig/Genome/1000Genomes/20130502
REF_DIR=$DIR/1000GP_Phase3/1000GP_Phase3

SNUHDMEXL=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_SNUHDMEX.na34.annot.csv.tab

## excutable 
IMPUTE2=/home/adminrig/Genome/1000Genomes/20130502/impute/impute_v2.3.2_x86_64_static/impute2

## OUTPUT SETTING
SHAPEIT=shapeit.1kg.phase3
IMPUTE=imputation
CHECK=check


#cd /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0.2014.v2/Analysis/Analysis.7000.20141230/batch
#cd /home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX/20150114/Analysis/Analysis.3062.20150114/batch/
cd $BATCH 

#grep -v ^AFFX SNPolisherPassSNV > SNPolisherPassSNV.SNV
#plink --bfile ChoSunUnivForImputation --extract SNPolisherPassSNV.SNV --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV --noweb

cd $ROOT_DIR
#ln -s $BATCH/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV* ./

#PlinkAlleleUpdate4VCFfrom.sh /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab
#PlinkAlleleUpdate4VCFfrom.sh $SNUHDMEXL
#ln -s $SNUHDMEXL.allele ./

#plink --bfile Frequency-updated  --update-alleles $SNUHDMEXL.allele --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.IndelFix --noweb

plink2 --bfile plink/AxiomGT1.calls.txt.extract.plink_fwd.gender  --extract $UniqMarker --geno 0.1 --hwe 0.001 --make-bed --out step1 --allow-no-sex --threads 20 

MakePlink_NotRedunVariant.sh step1 

for chr in  $( cut -f 1 $2  | egrep -v "(M|X|Y)" |  sed 's/^chr//' | sort | uniq | sort -nr ); 
	do plink2 --bfile step1.NotRedunVariants --chr $chr --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr$chr --allow-no-sex --threads 20;
done 

else

	usage "Axiom_KORV1_0.na34.annot.csv.tab.unique.Marker TargetRegion"
fi


