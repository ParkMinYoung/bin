
perl -F'\t' -anle'
if($.==1){
    #shift@F;
    @col=@F
}else{

    map { $h{ $col[$_] }{ $F[0] } = $F[$_] } 1..$#F;
    push @row, $F[0];
}

}{

print join "\t", "probeset-id", @row;
shift@col;
for $i ( @col ){
    print join "\t", $i, (map {  $h{$i}{ $row[$_] } } 0..$#row);
}
' $1 > $1.Transform.NotReorder 

