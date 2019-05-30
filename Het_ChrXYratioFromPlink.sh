
plink2 --bfile $1 --chr 23 --recode12 --out X --allow-no-sex --threads 5

# excute time : 2016-10-14 17:24:48 : get geno count
perl -F"\s+" -MMin -ane'chomp@F; $line=join " ", @F[6..$#F]; (@geno) = $line=~/(\d \d)/g; map {$h{$F[0]}{$_}++ } @geno; }{ mmfss("geno.count", %h)' X.ped 


# excute time : 2016-10-14 17:32:56 : get het rate per sample
perl -F'\t' -MMin -anle'$het_rate = $F[3]/sum(@F[1..4]);if($.==1){print join "\t", qw/ID Het/}else{ print join "\t", $F[0], $het_rate}' geno.count.txt > HetRatePerID 


# excute time : 2016-10-14 17:34:37 : Add X/Y ratio
join.h.sh HetRatePerID $KNIH1/AnalysisResult/Summary.txt 1 1 12 > HetRatePerID.out 


# excute time : 2016-10-14 17:35:46 : Add header
AddHeader.sh HetRatePerID.out HetRatePerID ID Het XYratio 


# excute time : 2016-10-14 17:42:41 : make png
R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/Het_ChrXYratio.R


