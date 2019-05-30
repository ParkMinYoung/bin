perl -F'\t' -anle'
$sum += $F[0] * $F[2];
$nt += $F[2];

if( $F[0] >= 10 ){
	$Q10nt += $F[2];
	$Q20nt += $F[2] if $F[0] >= 20 ;
	
}

}{ 
print join "\t", qw/file total_bases mean_qscore Q10Per Q20Per/;
print join "\t", $ARGV, $nt, $sum/$nt, $Q10nt/$nt, $Q20nt/$nt;
' $1 > $1.summary

