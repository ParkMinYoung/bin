#!/bin/sh

if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -anle'
BEGIN{
		$chr{MT}=26;
		$chr{M}=26;
		$chr{X}=23;
		$chr{Y}=24;
#pseudo X
#$chr{X}=25;
}

if(@ARGV){

	$chromosome = $F[2];
	$position = $F[3];
	$snp = $F[1];
	$chromosome =~s/chr//;

	$chr = $chr{$chromosome} ?  $chr{$chromosome} : $chromosome;
	$pos = $position;

#print join "\t", $chr, $pos;
	$h{$snp}{chr}=$chr;
	$h{$snp}{pos}=$pos;
}else{
	if(/^probeset_id|^rs/){
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

plink --tfile $2  --make-bed --out $2 --noweb

else
	echo "$0 MarkerInfo[chr,pos,marker] Genotype.matrix";
	echo "$0 /home/adminrig/Genome/SNP6.0/GenomeWideSNP_6.na32.annot.csv.tab[3,4,2] Genotype.matrix";
	exit;
fi

