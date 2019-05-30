#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	zcat $1 | \
	#cat $1 | \
	perl -F'\t' -anle'next if /^#/;
	@vars = split ",", $F[4];
	$geno="$F[3];$F[4]";
	for $var ( @vars ){
		($ref_len,$var_len)=(length $F[3],length $var);
		if($ref_len == 1 && $var_len==1){
			# SNP
			 print join "\t",$F[0],$F[1]-1,$F[1],"SNP;$geno"
			# print join "\t",$F[0],$F[1],$F[1],"SNP;$geno"
		}elsif($ref_len>$var_len){
			# Deletion
			$end=$F[1]+$ref_len-1;
			print join "\t", $F[0],$F[1]-1,$end,"Deletion;$geno"
		}elsif($ref_len<$var_len){
			# Insertion
			$end=$F[1]+$ref_len-1;
			print join "\t", $F[0],$F[1]-1,$end,"Insertion;$geno"
		}
		else{die "error!!"}
	}' | sort | uniq > $1.bed
else
	usage "XXX.vcf.gz"
fi

