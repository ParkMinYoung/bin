ls $@ | sort | perl -MFile::Basename -nle'
/\/(.+)_\w{6,7}_L00\d_(R\d)/; 
push @{$h{"$1-$2"}},$_ 
}{ 
		map { 
				$h{$_}->[0]=~/\/(\S+_\w{6}.+)/;
				($f,$d) = fileparse($1);
				print "zcat @{$h{$_}} | gzip -c > $f &"
		} sort keys %h '
