perl -F'\t' -anle'$F[0]=~/(\w+):(\d+)-(\d+)/; print join "\t", $1, $2-1, $3, $F[2] if $.>1' $1 > $1.bed
