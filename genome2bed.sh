perl -F'\t' -anle'
BEGIN{
$chunk=5000000;
}
$h{$F[0]}=$F[1] 
}{

for $chr(sort keys %h){
    $max = $h{$chr};
    $iter=0;
    while( $max > $chunk * $iter ){
        $s= $chunk * $iter + 1;
		$iter++;
		$end = $chunk * $iter;
		$e= $max > $end ? $end : $max ;
	print join "\t", $chr, $s, $e, $max;
    }
}
' /home/adminrig/workspace.min/IonTorrent/IonTorrentDB/hg19.genome

