#!/bin/sh
source ~/.bash_function

if [ $# -ge 2 ] && [ -f "$1" ] && [ -f "$2" ];then

ILEN=$3
LEN=${ILEN:-31}
# Write Single Read flag
WSRF=$4

paste $1 $2 | \
perl -F'\t' -MList::MoreUtils=firstidx -asnle'BEGIN{
open $P1,">$p1.TrimLastRepeat"; 
open $P2,">$p2.TrimLastRepeat";
if($singleF){
	open $S1,">$p1.TrimLastRepeat.single"; 
	open $S2,">$p2.TrimLastRepeat.single";
}		
}
push @p1, $F[0];
push @p2, $F[1];
if($.%4==0){
	#print join "\n",@p1,@p2;
	
	if( $p1[1] =~ s/((TG){3,}|(GT){3,}|(CA){3,}|(AC){3,})(A|C|G|T)?$// ){
		$p1[3] = substr $p1[3], 0, length($p1[1])
	}

	if( $p2[1] =~ s/((TG){3,}|(GT){3,}|(CA){3,}|(AC){3,})(A|C|G|T)?$// ){
		$p2[3] = substr $p2[3], 0, length($p2[1])
	}

	$p1_len = length $p1[1];
	$p2_len = length $p2[1];

	if( $p1_len > 0 && $p2_len > 0 ){
		$log{both.pass}++;
		print $P1 join "\n", @p1;
		print $P2 join "\n", @p2;
	}elsif( $p1_len == 0 && $p2_len == 0 ){
		$log{both.fail}++
	}elsif( $p1_len == 0 ){
		$log{p1.out}++;
		print $S2 join "\n", @p2;
	}elsif( $p2_len == 0 ){
		$log{p2.out}++;
		print $S1 join "\n", @p1;
	}
@p1=();
@p2=();
$log{total}++
}
}{ close $P1; close $P2;
if($singleF){close $S1; close $S2}
map{print "$_\t$log{$_}" } sort keys %log 
' -- -p1=$1 -p2=$2 -len=$LEN -singleF=$WSRF > $1.TrimLastRepeat.log
else
	usage "fastq1 fastq2 [length:31] [singleReadWrite:0|1]"
fi

