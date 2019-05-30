perl -F"\t" -anle'$s+=$F[2]-$F[1] }{ print "$ARGV\t$s"' $1
