 ls \@* | perl -F'\t' -MMin -nle'BEGIN{%h=h("DMET.mapping",1,2)} /(\@\d+)/; $bar=$1; if( $h{$bar} ){ $c=$_; s/$bar/$h{$bar}/; print "mv $c $_"} ' | sh
