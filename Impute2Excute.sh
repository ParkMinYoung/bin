#!/bin/sh

. ~/.bash_function
. ~/.GATKrc

G1K=/home/adminrig/Genome/1000Genomes/Impute2/ALL.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nosing
HAP=$G1K/haplotype_2013Dec
LEGEND=$G1K/legend_2013Dec
MAP=$G1K/map_2013Dec

if [ $# -eq 3 ];then

#RS="rs123"
#CHR=chr4
#POS=44638017

RS=$1
CHR=$2
POS=$3

SPAN=1000000
SPAN=1500000

PRE=$(expr $POS - $SPAN)
POST=$(expr $POS + $SPAN)

impute2 -h $HAP/CHB_JPT_ALL.$CHR.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nosing.haplotypes \
-l $LEGEND/ALL.$CHR.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nosing.legend \
-m $MAP/genetic_map_${CHR}_combined_b37.txt \
-g CJH_QC.gen \
-align_by_maf_g -Ne 20000 \
-int $PRE $POST \
-i $RS.$CHR.info \
-o $RS.$CHR.out \
-r $RS.$CHR.summary

impute2geno $RS.$CHR.out | grep $RS > $RS.$CHR.out.geno

else
	usage "rsid chr1 1234567"
fi

