perl -F'\t' -anle'
if($.==1){
    print;
}else{
    print join "\t", $F[0], ( map { join "", sort( split "", $_ ) } @F[1..$#F] );
}' $1 > $1.GenoSort
