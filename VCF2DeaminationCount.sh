#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then


for i in `vcf.sample.sh $1`
     do vcftools.extract.sample.DP30.GQ99.onlySNP.sh $1 $i 30 99 
done


perl -F'\t' -MMin -ane'$geno = "$F[3]$F[4]"; if(/^#/){next}elsif(length($geno)==2){ $h{$ARGV}{$geno}++ } }{ mmfss("deamination", %h)' `ls *vcf | grep -v $1`


perl -F'\t' -MMin -ane'$geno = "$F[3]$F[4]"; $ARGV=~/(.+)\.vcf/; $id=$1; if(/^#/){next}elsif(length($geno)==2){ $geno = join " vs ", sort $F[3], $F[4];  $h{$geno}{$id}++ } }{ mmfss("deamination", %h)' `ls *vcf | grep -v $1` 

R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/Deamination.R


 mv deamination.txt deamination.sortGeno.txt
 mv GenotypeCount.png GenotypeCount.sortGeno.png


 perl -F'\t' -MMin -ane'$geno = "$F[3]$F[4]"; $ARGV=~/(.+)\.vcf/; $id=$1; if(/^#/){next}elsif(length($geno)==2){ $geno = join " vs ", $F[3], $F[4];  $h{$geno}{$id}++ } }{ mmfss("deamination", %h)' `ls *vcf | grep -v $1`

 R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/Deamination.R

else
	usage "XXX.vcf"
fi



