perl -F'\t' -anle'
if( ! $h{$F[9]}++ ){
	$F[0]=~s/^\d+\.//;
	print join "\t", @F[0,3,6,11,7,8,16,17,18,19,14,4,20,21];
}' $1 > $1.table
# vep.txt
