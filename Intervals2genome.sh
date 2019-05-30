#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then
perl -nle'/(\w+):(\d+)-(\d+)/; $h{$1} = $3 if $h{$1} < $3;  }{ map { print join "\t", $_, $h{$_} } sort keys %h' $1 
#perl -nle'/(\w+):(\d+)-(\d+)/; $h{$1} = $3 if $h{$1} < $3;  }{ map { print join "\t", $_, $h{$_} } sort keys %h' Acorus_calamus_NC_007407.fasta.ann.intervals

else
	usage "XXX.intervals"
fi

