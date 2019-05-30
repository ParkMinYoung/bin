perl -MFile::Basename -le'map{$f=fileparse($_);$f=~/\.(.+)\.pdf/;push @{$h{$1}}, $_;}@ARGV; 
END{map{ push @out, @{$h{$_}} } sort keys %h; print "@out"}' $@

