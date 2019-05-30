perl -F'\t' -anle'$F[5]--; ($s,$e)=@F[5,6]; next if "$F[5].$F[6]"=~/---/; $s++ if $F[3]==3; print join "\t", "chr$F[4]",$s,$e,"$F[1];$F[2]" if $F[4]=~/(\d+|X|Y|M)/' $1 > $1.bed


# $F[3] = 1 ? deletion
# $F[3] = 2 ? snp
# $F[3] = 3 ? insertion

