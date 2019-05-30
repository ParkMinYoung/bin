#!/bin/sh

## usage 
## sh Interval2EachChr.sh  SureSelect_All_Exon_G3362_with_names.v2.hg19.bed.merged.intervals > SureSelect_All_Exon_G3362_with_names.v2.hg19.bed.merged.intervals.perChr


source ~/.bash_function
if [ -f "$1" ] & [ $# -eq 2 ] ;then

File=$1
LIMIT=$2
mergeBed -i $File -nms | \
perl -F'\t' -MMin -asnle'
$F[1]++;
($c,$s,$e)=@F[0..2];

$length = $e-$s+1;
$len{$c} += $length;
$len{"0.Total"} += $length;

$tmp_len += $length;
push @tmp_line, "$c:$s-$e";

if($tmp_len >= $limit ){
		$count++;
		$num= sprintf "%06s", $count;
		$c=~s/chr//;
		$id="$num.$c";
		$h{$id}= join "\n", @tmp_line;
		@tmp_line=();
		$tmp_len=0;
}


}{  $dir="Custom.Interval2EachChr.Size.$limit";
	mkdir $dir;
	map { 
		  open my $F, ">$dir/$_.intervals";
		  print $F $h{$_};
		  close $F
		} sort keys %h;
	map { print "$_\t$len{$_}" } sort {$a<=>$b} keys %len
' -- -limit=$LIMIT $File

else
		usage "XXX.bed [10000]"
fi
