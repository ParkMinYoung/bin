perl -F'\t' -anle'$F[4]="chr$F[4]"; print join "\t", @F[4,5,6], (join ";", @F[0,2]) if $.>1' $1 > $1.bed
