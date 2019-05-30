
perl -F'\t' -MMin -MList::Util=sum,max,min -asne'chomp@F;
$h{$F[3]}+=$F[4] if !/^(all|genome)/;

if( ! $chr{$F[0]} ){
        $chr{$F[0]}++;
        $target_len += $F[5];
}

}{

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


###chr1    0       249250621       0       30347065        249250621       0.1217532
###chr1    0       249250621       1       2863810 249250621       0.0114897
###chr1    0       249250621       2       4713237 249250621       0.0189096
###chr1    0       249250621       3       7391106 249250621       0.0296533
###chr1    0       249250621       4       10624764        249250621       0.0426268
###chr1    0       249250621       5       14080934        249250621       0.0564931
###chr1    0       249250621       6       17307032        249250621       0.0694363
###chr1    0       249250621       7       19815428        249250621       0.0795000
###chr1    0       249250621       8       21325184        249250621       0.0855572
###chr1    0       249250621       9       21545476        249250621       0.0864410


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

