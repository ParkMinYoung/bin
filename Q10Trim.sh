#!/bin/sh
source ~/.bash_function

if [ $# -ge 2 ] && [ -f "$1" ] && [ -f "$2" ];then

ILEN=$3
LEN=${ILEN:-31}

IQ=$5
Quality=${IQ:-20}
# Write Single Read flag
WSRF=$4

paste $1 $2 | \
perl -F'\t' -MList::MoreUtils=firstidx -asnle'BEGIN{
open $P1,">$p1.Q".$QS."Trim"; 
open $P2,">$p2.Q".$QS."Trim";
if($singleF){
	open $S1,">$p1.Q".$QS."Trim.single"; 
	open $S2,">$p2.Q".$QS."Trim.single";
}		
}
push @p1, $F[0];
push @p2, $F[1];
if($.%4==0){
	#print join "\n",@p1,@p2;
	
	@p1q=map{$_-64} unpack "C*",$p1[3];
	@p2q=map{$_-64} unpack "C*",$p2[3];

	#print "@p1q\t@p2q";
	$p1_idx=firstidx { $_ < $QS } @p1q;
	$p2_idx=firstidx { $_ < $QS } @p2q;
	
	#print "$p1_idx\t$p2_idx";
	$p1_idx=length $p1[3] if $p1_idx == -1;
	$p2_idx=length $p2[3] if $p2_idx == -1;
	if($p1_idx==0 && $p2_idx==0){
		$log{both.out}++
	}elsif($p1_idx>=$len && $p2_idx>=$len){
		$p1[1]=substr $p1[1],0,$p1_idx;
		$p1[3]=substr $p1[3],0,$p1_idx;
		print $P1 join "\n",@p1;

		$p2[1]=substr $p2[1],0,$p2_idx;
		$p2[3]=substr $p2[3],0,$p2_idx;
		print $P2 join "\n",@p2;
		$log{pair}++
	}elsif($p1_idx<$len && $p2_idx<$len){
		$log{"both.short"}++
	}elsif($p1_idx<$len){
		$p2[1]=substr $p2[1],0,$p2_idx;
		$p2[3]=substr $p2[3],0,$p2_idx;
		print $S2 join "\n",@p2 if $singleF;
		$log{"p1.short"}++
	}elsif($p2_idx<$len){
		$p1[1]=substr $p1[1],0,$p1_idx;
		$p1[3]=substr $p1[3],0,$p1_idx;
		print $S1 join "\n",@p1 if $singleF;
		$log{"p2.short"}++
	}
@p1=(); @p2=();
$log{total}++
}
}{ close $P1; close $P2;
if($singleF){close $S1; close $S2}
map{print "$_\t$log{$_}" } sort keys %log 
' -- -p1=$1 -p2=$2 -len=$LEN -singleF=$WSRF -QS=$Quality > $1.Q${Quality}Trim.log

else
	usage "fastq1 fastq2 [length:31] [singleReadWrite:0|1] [QualityScore:20]"
fi

