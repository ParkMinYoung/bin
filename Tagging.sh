#!/bin/sh

. ~/.bash_function

if [ $# -eq 3 ]; then

CHR=$1;
# chr4
INTERVAL=$2
# 4:108908869-108958331
GENE=$3

G1000=/home/adminrig/Genome/1000Genomes/20110521
VCF=$G1000/ALL.$CHR.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz
JPT=$G1000/JPT.ind
#JPT=$G1000/CBH.ind
#JPT=$G1000/CBH.JPT.ind

tabix -fh $VCF $INTERVAL > $GENE.vcf
vcftools --vcf $GENE.vcf --remove-indels --out $GENE.SNP --recode

#vcftools --vcf HADH.SNP.recode.vcf --plink --out HADH.SNP
#plink --file HADH.SNP --keep /home/adminrig/Genome/1000Genomes/20110521/JPT.ind --out HADH.JPT --noweb --recode
#cut -f2,4 HADH.SNP.map > HADH.JPT.info


:
pseq $GENE.SNP new-project
pseq $GENE.SNP load-vcf --vcf $GENE.SNP.recode.vcf
pseq $GENE.SNP write-ped --name $GENE.SNP.final

perl -F'\t' -anle'print join "\t", $F[0],$F[0], 0,0,1,1'  $GENE.SNP.final.tfam  > $GENE.SNP.final.tfam.bak
mv -f $GENE.SNP.final.tfam.bak $GENE.SNP.final.tfam
plink --tfile $GENE.SNP.final --keep $JPT --recode --out $GENE.SNP.final --noweb
cut -f2,4 $GENE.SNP.final.map  > $GENE.SNP.final.info

java -jar `which Haploview.jar` -n -log $GENE.SNP.final.hap -out $GENE.SNP.final.hap -pedfile $GENE.SNP.final.ped -info $GENE.SNP.final.info -dprime -png -blockoutput GAB -minMAF 0.001 -minGeno 0.75 -hwcutoff 0.0010  -missingCutoff .5 -pairwiseTagging -tagrsqcutoff .8 


else
	usage "chr4 4:108908869-108958331 HADH"
fi


# perl -F'\t' -anle'$ARGV=~/(.+)\.SNP/;print join "\t", $1, $F[1],"chr$F[0]",$F[3]' *map > Marker.info
# perl -nle'if(/^#/){$flag=0;print "$ARGV\t$_"}elsif(/^Test/){$flag=1;print "$ARGV\t$_"}elsif($flag){print "$ARGV\t$_"}' *.TAGS  > Marker.tagging
