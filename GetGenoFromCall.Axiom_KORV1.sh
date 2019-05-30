#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\t' -anle'

if(@ARGV){
($s,$A,$B) = @F[7,11,12];

	if($s eq "-"){
		$A =~ tr/ACGT/TGCA/;
		$B =~ tr/ACGT/TGCA/;
	}

	$h{$F[0]}{0} = "$A$A";
	$h{$F[0]}{1} = join "", sort ($A, $B);
	$h{$F[0]}{2} = "$B$B";
	$h{$F[0]}{-1} = "NN";
}elsif(!/^#/){
	if(/^probeset_id/){
		print
	}else{
		@geno = map { $h{$F[0]}{$_} } @F[1..$#F];
		print join "\t", $F[0], @geno;
	}
} ' $1 $2 > $2.fwd.geno

# CsvAnnotationFile.v1.txt.tab AxiomGT1.calls.txt > AxiomGT1.calls.txt.geno

else
	echo "csv2tab.sh Annotation.csv > Annotation.csv.tab"
	usage "$LIB6/GenomeWideSNP_6.na33.annot.csv.tab birdseed-v2.calls.txt > birdseed-v2.calls.txt.fwd.geno"
fi


