#!/bin/sh

. ~/.bash_function

if [ $# -eq 2 ] & [ -f "$2" ];then

perl -F'\s+' -MMin -MList::Util=min -asne'chomp@F; next if !/CEL/; $h{$F[0]}{$F[1]}=$F[2]; $h{$F[0]}{$F[1]."_QScore"}=$F[3]; $h{$F[0]}{QScore}=min($h{$F[0]}{QScore}||1, $F[4]); $h{$F[0]}{AB}=join "\|", sort($h{$F[0]}{"1"},$h{$F[0]}{"2"}) }{ mmfss($output, %h) ' -- -output=$1 $2

else
	usage "HLA_4dig_A AxiomHLA_4dig_A_Results.txt"
fi

