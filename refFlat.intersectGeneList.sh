#!/bin/sh

source ~/.bash_function
GATK_param


DBSNP=$2
DB=${DBSNP:=$DBSNP132}

if [ -f "$1" ];then

	Name=$(basename $DB)
	perl -F'\t' -anle'
		if(@ARGV){
			$h{$F[0]}=1
		}elsif($h{$F[0]}){
			$h{$F[0]}++;
			print "$F[0]\t$_"
		}
		}{ 
			map{print STDERR if $h{$_}==1} sort keys %h
		' $1 $DB 2> $1.uniq > $1.$Name.intersect

else
	usage "RsList [ dbSNP132 ]"
fi
