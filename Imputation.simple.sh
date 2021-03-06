#!/bin/bash

. ~/.bash_function


if [ -f "$1.bed" ] & [ -f "$2" ];then


## check bim file
## must check redundant genotype and site
## if not check, get the error shapeit step


PLINK=$1
OUT=$PLINK.unique

#LIB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1.1/Axiom_KORV1_1.na35.annot.csv.tab
LIB=$2





## configure
TREAD=80
BATCH=$PWD
ROOT_DIR=$PWD
WD=$ROOT_DIR
DIR=/home/adminrig/Genome/1000Genomes/20130502
REF_DIR=$DIR/1000GP_Phase3/1000GP_Phase3


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

PlinkAlleleUpdate4VCFfrom.sh $LIB
ln -s $LIB.allele ./

#plink --bfile Frequency-updated  --update-alleles $SNUHDMEXL.allele --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.IndelFix --noweb

plink --bfile $PLINK --extract $LIB.unique.Marker --make-bed --out $OUT --noweb


for chr in $(seq 1 22)
	do plink --bfile $OUT --chr $chr --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr$chr --noweb
done 


##############
## test step
##############

OUT=$WD/$CHECK
mkdir $OUT
for i in {1..22};
do 
	#$DIR/shapeit/shapeit -check -B $WD/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr1 -M $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/genetic_map_chr1_combined_b37.txt --input-ref $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_chr1_impute_macGT1.hap.gz $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_chr1_impute_macGT1.legend.gz $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3.sample --output-log $WD/KORV1_chr1_shapeitv2_log
	echo "$DIR/shapeit/shapeit -check -B $WD/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr${i} -M $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/genetic_map_chr${i}_combined_b37.txt --input-ref $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_chr${i}_impute_macGT1.hap.gz $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_chr${i}_impute_macGT1.legend.gz $DIR/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3_impute_macGT1/ALL_1000G_phase1integrated_v3.sample --output-log $OUT/KORV1_chr${i}_shapeitv2_log --thread 8"
done > shapeit.test.sh

sh shapeit.test.sh


##############
## shapeit step
##############

OUT=$WD/$SHAPEIT
mkdir $OUT
for i in {22..1};
do 
	echo "$DIR/shapeit/shapeit -B $WD/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr${i} -M $DIR/1000GP_Phase3/1000GP_Phase3/genetic_map_chr${i}_combined_b37.txt --effective-size 14269 --output-max $OUT/chr${i}_phased.haps $OUT/chr${i}_phased.sample -T $TREAD --output-log $OUT/chr${i}_shapeitv2_log"
done > shapeit.1kg.phase3.sh

sh shapeit.1kg.phase3.sh




##############
## impute step
##############


OUT=$WD/$IMPUTE
mkdir $OUT

genome2bed.sh | grep -v -e chrM -e chrX  -e chrY | \
perl -F'\t' -asnle'
($chr, $start, $end, $len) = @F;
$map = "$ref_dir/genetic_map_${chr}_combined_b37.txt";
$hap = "$ref_dir/1000GP_Phase3_${chr}.hap.gz";
$legend = "$ref_dir/1000GP_Phase3_${chr}.legend.gz";
$known_hap = "$shapeit/${chr}_phased.haps";
$out = "${chr}_${start}_${end}";
print "$impute -use_prephased_g -m $map -h $hap -l $legend -known_haps_g $known_hap -int $start $end buffer 1000 Ne 14269 -o_gz -o $out_dir/$out -filt_rules_l \"EAS==0\" -allow_large_regions"
' -- -impute=$IMPUTE2 -ref_dir=$REF_DIR -out_dir=$WD/$IMPUTE -shapeit=$WD/$SHAPEIT > impute.script.sh 


cat impute.script.sh | xargs -n23 -P 80 wrapper.sh
cat $OUT/*_info.bed > imputation.bed

else
	usage "PLINK Axiom_Lib.csv"
fi

