#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
GATK_param


SNP=$2
DB=${SNP:=$DBSNP}

if [ -f "$1" ];then

	Name=$(basename $DB)
	perl -F'\t' -anle'
		if(@ARGV){
			$h{$F[0]}=1
		}elsif($h{$F[4]}){
			$h{$F[4]}++;
			print "$F[4]\t$_"
		}
		}{ 
			map{print STDERR if $h{$_}==1} sort keys %h
		' $1 $DB 2> $1.uniq > $1.$Name.intersect

else
	usage "RsList [ dbSNP132 ]"
fi
