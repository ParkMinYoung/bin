 cut -f2 $1 | perl -F':' -anle' $k=join ":", @F[0,1], sort(@F[2,3]);  push @{ $h{$k} }, $_   }{  map {   print join "\t", $h{$_}[0], $_ if  @{ $h{$_} } == 1 && $h{$_}[0] ne $_    } sort keys %h'
