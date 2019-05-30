 perl -F'\t' -anle'$F[0]=~s/HWI-D00574:199:C9J38ANXX://; print ">$F[0]\n$F[9]"' $1 > $1.fa
