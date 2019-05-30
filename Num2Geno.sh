perl -F'\t' -anle'
if(@ARGV){
    ($m, $s, $a, $b) = @F[2,7,11,12];
    if( $s eq "-" ){
        $a=~tr/ACGT/TGCA/;
        $b=~tr/ACGT/TGCA/;
    }

    $h{$m}{-1} ="NN";
    $h{$m}{0}  = $a.$a;
    $h{$m}{1}  = join "", sort($a, $b);
    $h{$m}{2}  = $b.$b;

}else{
    if( ++$c == 1 ){
        print;
    }elsif( defined $h{$F[0]} ){
	    print join "\t", $F[0], (map { $h{$F[0]}{$_} } @F[1..$#F]);
    }
}' $1 $2
# /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab TaqManGenotype.txt

