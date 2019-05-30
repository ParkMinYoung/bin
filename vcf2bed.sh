perl -F'\t' -anle'
next if /^#/;

$ref_len = length $F[3];
$var_len = length $F[4];

if( $ref_len + $var_len == 2 ){
	print join "\t", $F[0],$F[1]-1,$F[1],(join ";", $F[2],"$F[3]/$F[4]");
}elsif( $ref_len == 1 && $var_len >1){
	print join "\t", $F[0],$F[1],$F[1],(join ";", $F[2],"$F[3]/$F[4]");
}elsif( $ref_len > 1 && $var_len == 1 ){
	print join "\t", $F[0],$F[1], $F[1]+$ref_len,(join ";", $F[2],"$F[3]/$F[4]");
}
' $1  


# 4       1129660 .       G       GTT     
# 4       1100037 rs35166968      TACAC   T

