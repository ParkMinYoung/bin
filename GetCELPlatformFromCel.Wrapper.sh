perl -nle'@F=split /\s+/, $_, 9; $F[8]=~s/(\s+|\(|\))/\\\1/g; system("./GetHeaderFromCel.pl $F[8]") ' $1 > $1.out

