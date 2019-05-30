#!/bin/sh

if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -anle'
if(@ARGV){

	$pos = $F[4];
	$chr = $F[3];

	if($F[3] =~ /^GM(\d+)/){
		$chr = $1+0;
	}elsif($F[3] =~ /^SCAFFOLD_(\d+)/){
		$chr = 21;
		$pos = 100000000 * $1 + $pos;
	}elsif($F[3] =~ /^NC_(\d+)/){
		$chr = 22;
	}

	$h{$F[0]}{chr}=$chr;
	$h{$F[0]}{pos}=$pos;
}else{
	if(/^probeset_id/){
		@sam = @F;
	}else{
		@GT=();
		map {  s/NN/00/; s/^(\w)/$1 /; push @GT, $_ } @F[1..$#F];
		print join "\t", $h{$F[0]}{chr}, $F[0], "0", $h{$F[0]}{pos}, @GT;
	}
}

}{ 
map { print STDERR join "\t", $_, $_, 0, 0, 0, 1 } @sam[1..$#sam];
' $1 $2 > $2.tped 2>$2.tfam

# ../CsvAnnotationFile.v1.txt.tab.Ref.new AxiomGT1.calls.txt.geno > AxiomGT1.calls.txt.geno.tped 2>AxiomGT1.calls.txt.geno.tfam

plink --tfile $2  --make-bed --out $2

else
	echo "$0 ../CsvAnnotationFile.v1.txt.tab.Ref.new AxiomGT1.calls.txt.geno";
	exit;
fi

