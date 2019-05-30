#!/bin/sh
source ~/.bash_function

if [ $# -ge 2 ] && [ -f "$1" ] && [ -f "$2" ];then

ILEN=$3
LEN=${ILEN:=50}
# Write Single Read flag

paste $1 $2 | \
perl -F'\t' -MList::MoreUtils=firstidx -asnle'BEGIN{
open $P1,">$p1.FixLenRMduplicate.fastq"; 
open $P2,">$p2.FixLenRMduplicate.fastq";
}

push @p1, $F[0];
push @p2, $F[1];
if($.%4==0){

	map { $_=substr $_, 0, $len } @p1[1,3], @p2[1,3];
	$str=$p1[1].$p2[1];

	if(! $h{$str}++ ){
#print  $str;
		print $P1 join "\n", @p1;
		print $P2 join "\n", @p2;
	}
@p1=(); @p2=();
}
}{ close $P1; close $P2;
map { print "$_\t$h{$_}" if $h{$_} > 1} sort {$h{$b} <=> $h{$a} } keys %h;
' -- -p1=$1 -p2=$2 -len=$LEN -singleF=$WSRF > $1.duplicates 
else
	usage "fastq1 fastq2 [length:31] [singleReadWrite:0|1]"
fi

