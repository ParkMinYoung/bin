#!/bin/sh
source ~/.bash_function

if [ $# -ge 2 ] && [ -f "$1" ] && [ -f "$2" ];then

ILEN=$3
LEN=${ILEN:-31}
# Write Single Read flag
WSRF=$4

paste $1 $2 | \
perl -F'\t' -MList::MoreUtils=firstidx -asnle'BEGIN{
open $P1,">$p1.BscoreTrim"; 
open $P2,">$p2.BscoreTrim";
if($singleF){
	open $S1,">$p1.BscoreTrim.single"; 
	open $S2,">$p2.BscoreTrim.single";
}		
}
push @p1, $F[0];
push @p2, $F[1];
if($.%4==0){
	#print join "\n",@p1,@p2;
	
	$p1_c = $p1[3] =~ tr/B//;
	$p2_c = $p2[3] =~ tr/B//;

	if($p1_c > 0 && $p2_c > 0){
		$log{both.out}++
	}elsif($p1_c > 0  && $p2_c == 0 ){
		print $S2 join "\n",@p2 if $singleF;
		$log{"p1.short"}++
	}elsif($p1_c == 0  && $p2_c > 0 ){
		print $S1 join "\n",@p1 if $singleF;
		$log{"p2.short"}++
	}elsif($p1_c == 0 && $p2_c == 0 ){
		print $P1 join "\n", @p1;
		print $P2 join "\n", @p2;
		$log{both.pass}++
	}else{
		$log{etc}++
	}
@p1=(); @p2=();
$log{total}++
}
}{ close $P1; close $P2;
if($singleF){close $S1; close $S2}
map{print "$_\t$log{$_}" } sort keys %log 
' -- -p1=$1 -p2=$2 -len=$LEN -singleF=$WSRF > $1.BscoreTrim.log
else
	usage "fastq1 fastq2 [length:31] [singleReadWrite:0|1]"
fi

