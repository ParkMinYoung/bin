#!/bin/bash

. ~/.bash_function

if [ -f "$1.bim" ];then

PLINK=$1

# excute time : 2017-11-01 10:58:55 : make input
cut -d" " -f1,2  $PLINK.fam | tr " " "\t" > input 


# excute time : 2017-11-01 10:20:58 : extract keep sample
for i in $(cut -f1 input); do grep -w $i input > $i.sample; done 


# excute time : 2017-11-01 10:24:01 : make plink per each
for i in *sample; do plink2 --bfile $PLINK --keep $i --make-bed --out sim.$i --allow-no-sex --threads 1; done


# excute time : 2017-11-01 10:35:30 : combination
#Combination.sh sim.*.bim | sed 's/.bim//g' | head


# excute time : 2017-11-01 11:06:48 : make id 2 A
perl -F'\s+' -i.bak -aple'$_=join " ", A, A, @F[2..$#F]' sim.*.fam


# excute time : 2017-11-01 11:03:29 : execute
Combination.sh sim.*.bim | \
	perl -nle' ($A,$B) = $_=~/(\.\d+\.\d+\.)sample.bim/g; print if $A eq $B' | \
	sed 's/.bim//g' | \
	perl -F'\t' -anle' print "plink2 --bfile $F[0] --bmerge $F[1].{bed,bim,fam} --merge-mode 6 --out $F[0]-$F[1] --allow-no-sex --threads 5"'  | sh 


# excute time : 2017-11-01 11:13:50 : ConcordantRate table
grep -e " concordance rate of " -e " overlapping calls," *log | perl -MMin -nle'BEGIN{ print join "\t", qw/A B Overlapping_calls Nonmissing_calls Conc_Num ConcordantRate/ } /sim\.(.+)\.sample-sim\.(.+)\.sample.log:(\d+) .+?(0.\d+|\d+)/;  print join "\t", $1, $2, $A, $B, $3, round($4*100,2) if ++$h{"$1-$2"} == 2; ($A,$B)=($3,$4)' > ConcordantRate


# excute time : 2017-11-01 11:14:17 : cleanup
[ -d simulation ] && rm -rf simulation 
mkdir simulation && mv sim.* *.sample input simulation 


else	

	usage "PLINK"
fi

