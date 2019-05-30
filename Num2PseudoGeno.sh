perl -F'\t' -anle'
BEGIN{
	$h{0} = "AA";
	$h{1} = "AC";
	$h{2} = "CC";
	$h{-1} = "NN";
}

if( $. == 1 ){
    print;
}else{
    $id = shift @F;
	print join "\t", $id, @h{@F};
}' $1 
# TaqManGenotype.txt

