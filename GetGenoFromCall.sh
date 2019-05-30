#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\t' -anle'
if(@ARGV){

	if($F[5] eq "-"){
		$F[7] =~ tr/ACGT/TGCA/;
		$F[8] =~ tr/ACGT/TGCA/;
	}

	$h{$F[0]}{0} = "$F[7]$F[7]";
	$h{$F[0]}{1} = join "", sort ($F[7], $F[8]);
	$h{$F[0]}{2} = "$F[8]$F[8]";
	$h{$F[0]}{-1} = "NN";
}elsif(!/^#/){
	if(/^probeset_id/){
		s/\.CEL//g;
		print
	}else{
		@geno = map { $h{$F[0]}{$_} } @F[1..$#F];
		print join "\t", $F[0], @geno;
	}
} ' $1 $2 > $2.geno

# CsvAnnotationFile.v1.txt.tab AxiomGT1.calls.txt > AxiomGT1.calls.txt.geno

else
	echo "csv2tab.sh Annotation.csv> Annotation.csv.tab"
	usage "Annotation.csv.tab Call.txt > Call.txt.geno"
fi


