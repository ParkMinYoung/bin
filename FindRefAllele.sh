#!/bin/sh

. ~/.bash_function

if [ $# -eq 4 ];then

		INPUT=$1
		A=$2
		B=$3
		REF=$4

		# -A=4 -B=5 -ref=11 Merge.eQTL.bed.flanking

		perl -F'\t' -sanle'
		($A,$B,$ref) = @F[3,4,10];

		$Remark = "";
		$QC="Pass";

		$ref = "-" if ! $ref;


		if( $A eq $ref ){
			$alt = $B;
		}elsif( $B eq $ref ){
			$alt = $A;
		}else{
			$QC = "Fail";
			$Remark = "Not matching Ref allele";
		}


		if( $ref eq "-" ){
			$type = "Insertion";
		}elsif( $alt eq "-" ){
			$type = "Deletion";
		}else{
			$type = "SNP";
		}

		print join "\t", $_, $QC, $Remark, $type, $ref, $alt;
		' -- -A=$A -B=$B -ref=$REF $INPUT

else
	usage "Merge.eQTL.bed.flanking.FindRefAllele 4(A column) 5(B column) 11(ref column)"
fi

