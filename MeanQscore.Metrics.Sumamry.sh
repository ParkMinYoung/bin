. ~/.perl
perl -F'\t' -MMin -ane'
if($.==1){
        print;
}elsif(/Total/){
        $Total=$F[1];
        $flag=1;
}elsif($flag){
        $F[0]=$ARGV;
        $F[1]=$Total;
        $flag=0;
        #print join "\t", @F;

        push @list, [ @F ];
        #print join "\t", $ARGV, @F;
}

}{

map { print join "\t", @{$_} } @list;
print "+++";

map { $sum += $_->[1]; $_->[6]/=2;$_->[7]/=2;$_->[8]/=2; } @list;
map { $_->[3] = sprintf "%0.2f", $_->[1]/$sum*100 } @list;

map { print join "\t", @{$_} } @list;

' $@

#$( ls *MeanQscore.Metrics.txt | grep -P -v "_S\d+_" )
#$( ls *MeanQscore.Metrics.txt | grep -P "_S\d+_" )
