 perl -F'\t' -MMin -anle'$h{@F+0}++ }{ show_hash(%h)' $1
