#!/bin/sh

source ~/.bash_function

#DEFAULT=/home/adminrig/Genome/dbSNP/snp132.txt
#DEFAULT=/home/adminrig/Genome/dbSNP/dbSNP135/snp135.txt
#DEFAULT=/home/adminrig/Genome/dbSNP/dbSNP137/snp137.txt
DEFAULT=/home/adminrig/Genome/dbSNP/dbSNP138/snp138.txt

SNP=$2
DBSNP=${SNP:=$DEFAULT}

if [ -f "$1" ] && [ -f "$DEFAULT" ];then

		perl -F'\t' -anle'
		if(@ARGV){
			$h{$_}++
		}elsif($h{$F[4]}){
			print; 
			$c++;
		}
		}{ print STDERR "output : $c"' $1 $DBSNP  > $1.dbsnp

else
		usage "rs_list_file [ $DEFAULT ]"
fi

#585	chr1	10468	10469	rs117577454	
