#!/bin/bash

. ~/.bash_function


if [ -f "$1" ];then
	
	output=$(basename $1).bed
	perl -F'\t' -anle'if($.==1){ print join "\t", qw/chr start end mean_dp/ }else{ if( $F[0]=~/(\w+):(\d+)-(\d+)/ ){ print join "\t", $1, $2-1, $3, $F[4] }elsif( $F[0]=~/(\w+):(\d+)/ ){ print join "\t", $1, $2-1, $2, $F[4] }  }' $1 > $output

else
	usage "XXX.sample_interval_summary"

fi

