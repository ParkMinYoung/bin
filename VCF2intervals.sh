perl -F'\t' -anle'
if(!/^#/){
	$ref = length($F[3]);
	$alt = length($F[4]);
	if($ref+$alt == 2 ){
		print "$F[0]:$F[1]-$F[1]";
	}elsif($ref > 1){
		#deletion
		$s = $F[1];
		$e = $F[1] + $ref - 1;
		print "$F[0]:$s-$e";
	}elsif($alt > 1){
		#insertion
		print "$F[0]:$F[1]-$F[1]";
	}
}' $1 > $1.intervals

