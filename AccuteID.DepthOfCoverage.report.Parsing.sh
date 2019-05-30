#!/bin/sh

DP=$1
HET=$2

perl -F'\t' -MMin -MList::Util=sum -asne'
chomp@F;
if( $. == 1){
	map {push @id, $1 if /^(.+?)(_base_counts)?$/ } @F[3..$#F];
	@head = (@F[0..2], @id);
#map { print "$_\n" } @id;
#exit;
}else{
	for $i ( 3..$#F ){
		if( $i%2==0 ){
			
			%Base=();
			map { /(\w):(\d+)/; $Base{$1}=$2 if $2} split " ", $F[$i];

			@base = sort { $Base{$b} <=> $Base{$a} } keys  %Base;
#print "$F[$i], $head[$i], $i : @base ", @Base{@base},"\n" ;

			$sum = sum @Base{@base};
			
			if ( $sum >= $Total ){

				if( @base == 1 ){
					$geno = $base[0]x2 
				}else{
					($A,$B) = @base[0,1];
#print "$A\t$B\t$sum\t$Total";
					$het = $Base{$B} / $sum;
					$geno = $het >= $Het ? join "", sort @base[0,1] : $base[0]x2;
				}
			}else{
				$geno = "NN";
			}
			
			$sam = $head[$i];
			$m{$F[0]}{$sam}=$geno;

		}
	}
}
}{ mmfss("DepthOfCoverage.report2Genotype.DP$Total.Het$Het",%m)
' -- -Total=$DP -Het=$HET AccuteID.DepthOfCoverage.report


### 0       Locus   chr1:30215072
### 1       Total_Depth     73
### 2       Average_Depth_sample    7.30
### 3       Depth_for_DNALink.PE.003        1
### 4       DNALink.PE.003_base_counts      A:0 C:0 G:0 T:1 N:0 
### 5       Depth_for_DNALink.PE.004        0
### 6       DNALink.PE.004_base_counts      A:0 C:0 G:0 T:0 N:0 
### 7       Depth_for_DNALink.PE.005        1
### 8       DNALink.PE.005_base_counts      A:0 C:0 G:0 T:1 N:0 
### 9       Depth_for_DNALink.PE.006        5
### 10      DNALink.PE.006_base_counts      A:0 C:0 G:0 T:5 N:0 
### 11      Depth_for_DNALink.PE.007        45
### 12      DNALink.PE.007_base_counts      A:0 C:4 G:1 T:40 N:0 
### 13      Depth_for_DNALink.PE.008        16
### 14      DNALink.PE.008_base_counts      A:0 C:0 G:0 T:16 N:0 
### 15      Depth_for_DNALink.PE.009        1
### 16      DNALink.PE.009_base_counts      A:0 C:0 G:0 T:1 N:0 
### 17      Depth_for_DNALink.PE.010        2
### 18      DNALink.PE.010_base_counts      A:0 C:0 G:0 T:2 N:0 
### 19      Depth_for_DNALink.PE.011        2
### 20      DNALink.PE.011_base_counts      A:0 C:0 G:0 T:2 N:0 
### 21      Depth_for_DNALink.PE.012        0
### 22      DNALink.PE.012_base_counts      A:0 C:0 G:0 T:0 N:0 
### [2] : ################################################################################
### [2] : ################################################################################
### File : [AccuteID.DepthOfCoverage.report]
###      

