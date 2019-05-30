
perl -F'\t' -anle'
if(/^#/){
	push @sample, $F[5];
	$sam = $F[5];
	$c++;
}else{
	$k=join "\t", @F[0..3];
	$h{$k}->[$c-1] = $F[5];
	
	if($F[4] ne "."){
		$var{$k} = $F[4];
	}elsif(! defined $var{$k}){
			$var{$k} ="."
	}
}

}{
	print join "\t", qw/#CHROM POS ID REF ALT/, @sample;
	for $site ( sort keys %h ){
		print join "\t", $site, $var{$site}, @{$h{$site}};
	}
' $@ > GPS.geno

