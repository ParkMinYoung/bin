#!/bin/bash

.  ~/.bash_function


if [ -f "$1" ];then

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



cd $ROOT_DIR


##############
## test step
##############

OUT=$WD/$CHECK
mkdir $OUT
for i in $( cut -f 1 $1  | egrep -v "(M|X|Y)" |  sed 's/^chr//' | sort | uniq | sort -nr );
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
for i in $( cut -f 1 $1  | egrep -v "(M|X|Y)" |  sed 's/^chr//' | sort | uniq | sort -nr );
do 
	echo "$DIR/shapeit/shapeit -B $WD/AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPassSNV.chr${i} -M $DIR/1000GP_Phase3/1000GP_Phase3/genetic_map_chr${i}_combined_b37.txt --effective-size 14269 --output-max $OUT/chr${i}_phased.haps $OUT/chr${i}_phased.sample -T $TREAD --output-log $OUT/chr${i}_shapeitv2_log"
done > shapeit.1kg.phase3.sh

sh shapeit.1kg.phase3.sh




##############
## impute step
##############


OUT=$WD/$IMPUTE
mkdir $OUT

cat $1 | \
perl -F'\t' -asnle'
($chr, $start, $end, $len) = @F;
$map = "$ref_dir/genetic_map_${chr}_combined_b37.txt";
$hap = "$ref_dir/1000GP_Phase3_${chr}.hap.gz";
$legend = "$ref_dir/1000GP_Phase3_${chr}.legend.gz";
$known_hap = "$shapeit/${chr}_phased.haps";
$out = "${chr}_${start}_${end}";
print "$impute -use_prephased_g -m $map -h $hap -l $legend -known_haps_g $known_hap -int $start $end buffer 1000 Ne 14269 -o_gz -o $out_dir/$out -allow_large_regions"
' -- -impute=$IMPUTE2 -ref_dir=$REF_DIR -out_dir=$WD/$IMPUTE -shapeit=$WD/$SHAPEIT > impute.script.sh 


cat impute.script.sh | xargs -n23 -P $TREAD wrapper.sh
#cat $OUT/*_info.bed > imputation.bed


else

	echo -e "\n\nTargetRegion Format\n"
	echo -e "chr19   40000001        45000000        59128983\n"
	echo -e "chr19   45000001        50000000        59128983\n"

	usage "TargetRegion"
fi

