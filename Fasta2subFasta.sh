perl -nle'if(/^>(\w+)/){$id=$1}
$h{$id}.="$_\n"
}{ map{ 
		open my $F,">$_.fa";
		print $F $h{$_};
		close $F
	   } sort keys %h' $1 
