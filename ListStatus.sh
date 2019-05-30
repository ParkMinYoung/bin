#!/bin/sh

. ~/.bash_function

OUT=$$.tmp

if [ $# -eq 4 ];then

perl -F'\t' -asnle'
BEGIN{
	$f1_col--;
	$f2_col--;
}

if(@ARGV){ 
		$h{$F[$f1_col]}=1 
}else{ 
		$h{$F[$f2_col]}=$F[$f2_col] if $h{$F[$f2_col]}; 
} 

}{ 
	map { print join "\t", $_, $h{$_} } sort keys %h
' -- -f1_col=$2 -f2_col=$4 $1 $3 >  $OUT

grep -w 1$ $OUT | cut -f1 > $1.missing
grep -v -w 1$ $OUT | cut -f1 > $1.found

#rm -rf $OUT

wc -l $1*

else
		usage "file1 f1_col file2 f2_col"
fi



