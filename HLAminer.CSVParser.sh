#!/bin/bash

if [ -f "$1" ];then

	perl -MMin -nle'BEGIN{print join "\t", qw/Gene Allele HLA_Type Score ExpectValue Confidence/}if(/^HLA-(\w+)/){$gene=$1; $flag=0}elsif(/Prediction #(\d)/){$allele=$1; $flag=1}elsif(/^$/){$flag=0}elsif($flag){ s/^\s+//g; s/,/\t/g; print join "\t", $gene, $allele, $_ }' $1 

else	

	usage "HLAminer.csv"

fi



