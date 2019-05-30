#!/bin/sh


perl -F'\t' -MMin -ane'
chomp@F;
if(/>>END_MODULE/){
	$flag="";	
}elsif(/>>(Basic Statistics)/){
	$id=$1;
	$flag++;
}elsif(/>>(Per .+)\t/){
	$id=$1;
	$flag++;
}elsif($flag){
	$h{$id}{$F[0]}{$ARGV}=$F[1];
}

}{
	map { %tmp = %{$h{$_}}; mmfsn($_,%tmp); } sort keys %h
' set*.txt
#set1.VP02226.R1.ACAGTG.L001.txt

