perl -F'\t' -anle'if(!/^#/){
    $F[0] = "chr$F[0]" if $F[0] !~ /^chr/;
	$F[4] = $F[3] if $F[4] eq ".";
	if( length $F[3] == 1 && length $F[4] == 1){
 		print STDOUT "$F[0]:$F[1] $F[3]/$F[4]"
	}else{
		print STDERR "$F[0]:$F[1] $F[3]/$F[4]"
	}
}' $1 2> $1.polyphen.indel > $1.polyphen.snp

