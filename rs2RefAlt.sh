#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -anle'
$r=length($F[7]);
$a=length($F[8]);

if( $F[6] eq "-"){
	$F[9] = reverse($F[9]);
	$F[9] =~ tr/ACGT/TGCA/;
}

@geno = split "\/", $F[9];

%ref=();
$ref=$F[7];
$ref{$ref}++;

for $i(@geno){
	if(!$ref{$i}){
		$alt=$i;
		last;
	}
}


if($r==1 && $a==1){
	print join "\t", @F[1,3,4], $ref, $alt;
}elsif($r>1){
	$F[3]= $F[2]+1;
	print join "\t", @F[1,3,4], $ref, $alt;
}elsif($a>1){
	print join "\t", @F[1,3,4], $ref, $alt;
}
#print join "\t", @F[1..9];
' $1 | grep -v "_" > $1.tab

else
	usage "rslist.output[dbsnp1XX file format]"
fi



 ## 0       973     1008
 ## 1       chr1    chr1
 ## 2       50909984        55496038
 ## 3       50909985        55496039
 ## 4       rs17106184      rs11206510
 ## 5       0       0
 ## 6       +       +
 ## 7       G       T
 ## 8       G       T
 ## 9       A/G     C/T
 ## 10      genomic genomic
 ## 11      single  single
 ## 12      by-cluster,by-frequency,by-hapmap,by-1000genomes        by-cluster,by-frequency,by-2hit-2allele,by-hapmap,by-1000genomes
 ## 13      0.162278        0.210949
 ## 14      0.234105        0.246931
 ## 15      intron  unknown
 ## 16      exact   exact
 ## 17      1       1
 ## 18
 ## 19      10      16
 ## 20      1000GENOMES,AFFY,COMPLETE_GENOMICS,GMI,HGSV,ILLUMINA,KRIBB_YJKIM,PERLEGEN,SSMP,TISHKOFF,        1000GENOMES,ABI,AFFY,BUSHMAN,COMPLETE_GENOMICS,CSHL-HAPMAP,ENSEMBL,EXOME_CHIP,ILLUMINA,KRIBB_YJKIM,PAGE_STUDY,PERLEGEN,PJP,SSAHASNP,SSMP,TISHKOFF,
 ## 21      2       2
 ## 22      A,G,    C,T,
 ## 23      385.000000,3911.000000, 582.000000,4576.000000,
 ## 24      0.089618,0.910382,      0.112834,0.887166,
 ## 25      maf-5-some-pop  maf-5-some-pop,microattr-tpa
 ## [2] : ################################################################################
 ## [2] : ################################################################################
 ## File : [rslist.output]


