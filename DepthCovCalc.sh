
perl -F'\t' -MMin -MList::Util=sum,max,min -asne'chomp@F;
$h{$F[1]}=$F[2] if /^all/;
}{
$target_len=$F[3];
@depth=sort {$a<=>$b} keys %h;
$min=min @depth;
shift;

$max=max @depth;
@range = 1 .. $max;
for $i( 1 .. $max ){
#print join "\t",$i,$h{$i},@range+0,(sum @h{@range}),"\n";
	
	$base{$i}{total} += sum @h{@range};

	$base{total}{total} += $h{$i};
	$per{$i}{total} = sprintf "%2.2f", $base{$i}{total}/$target_len*100;
	shift @range;
}

$min=0 if $min>0;
$base{$min}{total} = $h{$min};
$per{$min}{total} = sprintf "%2.2f", $base{$min}{total}/$target_len*100;
mmfsn("$f.DepthBase",%base);
mmfsn("$f.DepthPer",%per)' -- -f=$1 $1

# 
# all     0       102596  5442505 0.0188509
# all     1       9659    5442505 0.0017747
# all     2       4174    5442505 0.0007669
# all     3       3373    5442505 0.0006198
# all     4       2879    5442505 0.0005290
# all     5       2707    5442505 0.0004974
# all     6       2982    5442505 0.0005479
# all     7       3106    5442505 0.0005707
# all     8       2985    5442505 0.0005485
# all     9       3101    5442505 0.0005698



