#!/bin/sh

if [ -f "$1" ];then

FixedLastColumn=1
ColumnSize=200

perl -F'\t' -asnle'
if($.==1){ 
		$op = @F; 
		map { 
				$s=$size*$_ + $fixcol+1; 
				$e=$size*($_+1) + $fixcol; 
				print "cut -f1-$fixcol,$s-$e OncoPrint.input.txt > OncoPrint.input.txt.$s-$e.txt"
		} 0 .. $#F/200; 
		exit
}' -- -size=$ColumnSize -fixcol=$FixedLastColumn $1  

else
	usage "XXX.txt or YYY.table"
fi

