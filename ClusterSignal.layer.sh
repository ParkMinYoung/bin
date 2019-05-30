perl -F'\t' -MMin -anle'
BEGIN{
	$miny = 0;
	$maxy = 20;
	$y = 7;
}
if(@ARGV){
	$h{$F[0]} = $F[1];
	$max = $F[1] if $max < $F[1];
	$interval = ($maxy - $miny)/$max;
}else{
	$new_y = $F[4] - $y;
	if( $h{$F[1]} ){
		$F[4] = $maxy - ($interval * $h{$F[1]}) + $new_y;
		print join "\t", @F;
	}
}' $1 $2 > $2.New.txt 
#}' Sample.20131209.1005.layer ClusterSignal.txt
