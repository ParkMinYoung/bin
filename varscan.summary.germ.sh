perl -nle'print "$ARGV\t$_"' `find files2use | grep COSMIC.genes60$` > germline.txt
