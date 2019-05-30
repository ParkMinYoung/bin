#!/bin/sh

. ~/.bash_function
. ~/.GATKrc

G1K=/home/adminrig/Genome/1000Genomes/Impute2/ALL.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nosing
HAP=$G1K/haplotype_2013Dec
LEGEND=$G1K/legend_2013Dec
MAP=$G1K/map_2013Dec

if [ -f "$1" ];then

RSLIST=RequestedRS.20140401
RSLIST=$1
PLINK=$2



grep -f $RSLIST $LEGEND/*legend > $RSLIST.out
plink --bfile $PLINK --maf 0.01 --hwe 0.000001 --recode --out $PLINK.out --noweb
gtool -P --ped $PLINK.out.ped --map $PLINK.out.map --og $PLINK.out.gen --os $PLINK.out.sample

perl -nle'/(chr\w+).+:(\w+)\s+(\d+)/;print "qsub -N $2 /home/adminrig/src/short_read_assembly/bin/sub Impute2Excute.sh $2 $1 $3\nsleep 15"' $RSLIST.out > 01.impute
sh 01.impute

sleep 10000

# grep rs *geno | cat -n | less -S
# cat *geno | cut -f2-
perl -F'\s+' -anle'if($.>2){ push @head, $F[0] } }{ print join "\t", "RS_ID", "CHR", "BP", "allele A", "allele B", @head '  $PLINK.out.sample > IMPUTE.out
perl -F'\t' -anle'$ARGV=~/(chr\w+)/; $F[0]=$F[1];$F[1]=$1;print join "\t", @F'  *geno >> IMPUTE.out

else
	usage "RSLIST_FILE PLINK"
fi


