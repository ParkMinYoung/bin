#!/bin/bash

. ~/.bash_function

DB=${2:-"/home/adminrig/Genome/CancerDatabases/DB.all"}


if [ -f "$1" ] && [ -f "$DB" ];then

perl -F'\t' -anle' 
if(@ARGV){
	$h{$F[0]} = $F[1];
}else{

	if(++$c==1){
		print join "\t", $_, "CancerDB"
	}else{ 
		$gene = $F[0];
		$gene =~s/^\`//; 
	
		$gDNA = $gene."|"."$F[1]:g.$F[2]$F[3]>$F[4]";
		$cDNA = $gene."|".$F[7];
		$var  = $gene."|".$F[15];
	
		$DB = $h{$gDNA} || $h{$cDNA} || $h{$var} || "unknown";
	
#print join "\t", @F, (join ":", $gDNA, $cDNA, $var), $DB
		print join "\t", @F, $DB
	}
}' $DB $1
#Variants.bySNVs.simple.3to1

else	

	usage "Variants.bySNVs.simple.3to1 [/home/adminrig/Genome/CancerDatabases/DB.all]"
fi


