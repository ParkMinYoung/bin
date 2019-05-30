#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then



F=$1
echo $L
echo line : $(( $(wc -l $F | awk '{print $1}') - 1))

echo unique sample : $( tail -n +2 $F | cut -f2 | sort | uniq | wc -l | awk '{print $1}' )

echo set : $( tail -n +2 $F | cut -f3 | sort | uniq | wc -l | awk '{print $1}' )


echo $L
echo Gender
tail -n +2 $F | cut -f6 | sort | uniq -c | awk '{print $2"\t"$1}'


echo $L
echo Gender Match
tail -n +2 $F | cut -f14 | sort | uniq -c | awk '{print $2"\t"$1}'

echo $L
echo Gender Match Status
tail -n +2 $F | grep -v -w 1 | cut -f14,16 | sort | uniq -c | awk '{print $3"\t"$2"\t"$1}' | sort -k1,1


echo $L
echo Pass Sample : $(perl -F'\t' -anle'if($.>1 && $F[4]>=0.82 && $F[7]>=98){print}' $F | wc -l | awk '{print $1}')

echo $L
echo Pass Status
perl -F'\t' -MMin -ane'chomp@F; if($.>1){ if($F[4]>=0.82 && $F[7]>=98){ $h{$F[15]}{Pass}++ }else{$h{$F[15]}{Fail}++};  $h{$F[15]}{Total}++ } }{ mmfss_print(%h)' $F

echo $L
echo mean stat : all sample
datamash -H mean 5  mean 8 mean 9 < $F

echo $L
echo mean stat : passed sample
perl -F'\t' -MMin -anle'if($.==1){print}elsif($F[4]>=0.82 && $F[7]>=98){print}' $F | datamash -H mean 5  mean 8 mean 9 



else
	usage "Summary.txt"
fi


