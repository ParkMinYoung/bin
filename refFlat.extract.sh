perl -F'\t' -anle'
if(@ARGV){
	$h{$F[0]}++
}elsif( $h{$F[0]} ){
	print;
	$h{$F[0]}++;
}

}{ map { print STDERR $_ if $h{$_} == 1 } keys %h ' $1 $2  > $1.refFlat.txt 2> $1.NoFinding

## Gene
#x
#y
#z

## refFlat.txt

