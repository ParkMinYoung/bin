#!/bin/sh

. ~/.bash_function
source ~/.GATKrc

if [ $# -ge 1 ];then

UCSCRefFLAT=$2
INREFFLAT=${UCSCRefFLAT:=$REFFLAT}

perl -F'\t' -anle'
if(@ARGV){
		$h{$_}++
}elsif($h{$F[0]}){
		$F[2]=~s/chr//; 
		$h{$F[0]}++;
		#print join "\t", @F[2,4,5,0] 
		print if $F[2] !~ /_/;
} 
}{ 
	map { print STDERR "$_" if $h{$_}==1 } sort keys %h
' $1 $INREFFLAT 2> $1.OffGene 1> $1.refFlat


awk '{print $3"\t"$5"\t"$6"\t"$1}' $1.refFlat > $1.refFlat.bed

else 
	usage "GeneList [refFlat.txt]"
fi
