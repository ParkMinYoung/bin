#!/bin/sh

. ~/.bash_function

if [ -f "$1" ]; then

perl -F'\t' -anle'
BEGIN{
	$Z2 = 0.9;
}

if( $F[8] >= $Z2 ){
	$h{$F[3]}{$F[1]}=$F[8];
	$h{$F[1]}{$F[3]}=$F[8];
}

}{
	for $sam1 (keys %h){
		@sam2 = sort { $h{$sam1}{$b} <=> $h{$sam1}{$a} } keys %{$h{$sam1}};
		@values = map { "$_;$h{$sam1}{$_}" } @sam2;

		print join "\t", $sam1, @values+0, @values;
	}
' $1 > $1.relationship
#merge.IBS.genome.tab.sort >merge.IBS.genome.tab.sort.relation

else
	usage "XXX.IBS.genome.tab"
fi



 ## $1      FID1    Genomewide6.0_KAREII_KoBB2-6197_M.CEL
 ## $2      IID1    Genomewide6.0_KAREII_KoBB2-6197_M.CEL
 ## $3      FID2    Genomewide6.0_KAREII_KoBB0804-290_M.CEL
 ## $4      IID2    Genomewide6.0_KAREII_KoBB0804-290_M.CEL
 ## $5      RT      UN
 ## $6      EZ      NA
 ## $7      Z0      0.3169
 ## $8      Z1      0.6831
 ## $9      Z2      0.0000
 ## $10     PI_HAT  0.3415
 ## $11     PHE     -1
 ## $12     DST     0.684200
 ## $13     PPC     1.0000
 ## $14     RATIO   8.5714

