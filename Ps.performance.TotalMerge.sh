perl -F"\t" -MMin -MList::Util=min,max -asne'
BEGIN{
	@list = map { --$_ } split ",", $cols;
}
chomp@F;
if(/^probeset_id/){
	#A.shuffle/1/Analysis/Output/Ps.performance.txt
	
    $ARGV=~/\/(\w+)\/(.+?)\/Analysis/;
    $batch="$1.$2";
    
    @header=@F;
	@col=@F[@list];
}else{

    map { $h{$F[0]}{$header[$_]} .= "$F[$_], " } @list;
	$total= sum(@F[8..11]);
	$A_Freq=sprintf "%.4f", ($F[8]*2+$F[9])/(($total-$F[11])*2);
   	$h{$F[0]}{Batch} .= "$batch, ";
	$h{$F[0]}{Count} .= "$total, ";
	$h{$F[0]}{A_Freq} .= "$A_Freq, ";
}
}{
@col=("Batch", "Count", "A_Freq", "Freq_diff", @col);

map { @freq=split ", ", $h{$_}{A_Freq};  $h{$_}{Freq_diff} = sprintf "%.4f", max(@freq) - min(@freq); } keys %h;

mmfss_ctitle("Ps.performance", \%h, \@col)
' -- -cols="2,3,4,5,6,15,16,17,18" $@
#./1/Analysis/Output/Ps.performance.txt.test ./2/Analysis/Output/Ps.performance.txt.test ./3/Analysis/Output/Ps.performance.txt.test

cut -f1,4,6- Ps.performance.txt  > Ps.performance.txt.input

