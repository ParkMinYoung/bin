#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -MList::AllUtils=sum,max,firstidx -anle'
BEGIN{ $depth=10;$maf=0.15 }

if($.==1){
	@header = @F;
	map { s/\s+Reads//; } @header[6..9];
	print join "\t", qw/#CHROM POS ID REF ALT/, $ARGV, qw/Depth MAF REF_DP ALT_DP Remark/;
	next;
}

@count = @F[6..9];

$total_depth = $F[5];

#if ( $total_depth >= $depth ){
	$max = max @count;
	$fir_max_idx = firstidx { $_ == $max } @count;
	$A = $header[$fir_max_idx+6];
	$A_dp = $count[$fir_max_idx];

	$count[$fir_max_idx]=0;

	$max = max @count;
	$sec_max_idx = firstidx { $_ == $max } @count;
	$B = $header[$sec_max_idx+6];
	$B_dp = $count[$sec_max_idx];

	$A_B = $A_dp + $B_dp;
	if( $B_dp == 0 ){
		$minor_freq=0
	}else{
		$minor_freq = $B_dp / $A_B;
	}

	if($B_dp == 0 || $maf > $minor_freq){
		$B = ".";
	}

	$var = $A eq $F[4] ? $B : $A;
	
	if( $minor_freq >= $maf ){
		if(  $A_B >= $depth ){
			print join "\t", @F[0,1,2,4], $var, (join "", sort $A,$B), $A_B, $minor_freq, $A_dp, $B_dp, "PASS";
		}else{
			print join "\t", @F[0,1,2,4], $var, (join "", sort $A,$B), $A_B, $minor_freq, $A_dp, $B_dp, "LowDP";
		}
	}else{
		if( $A_B >= $depth ){
			print join "\t", @F[0,1,2,4], $var, (join "", sort $A,$A), $A_B, $minor_freq, $A_dp, $B_dp, "PASS";
		}else{
			print join "\t", @F[0,1,2,4], $var, (join "", sort $A,$A), $A_B, $minor_freq, $A_dp, $B_dp, "LowDP";
		}
	}

#} 
' $1 > $1.GPS.geno

else
	usage "allele_count.txt"
fi

