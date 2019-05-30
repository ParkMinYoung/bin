#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] && [ $# -eq 2 ];then

	total=$(ColSum.sh $2 $1)
 
	perl -F'\t' -asnle'
	BEGIN{ $col--; }
	if($.==1){
			print join "\t", $_, qw/acc total pct/
	}else{ 
			$acc+=$F[$col]; 
			print join "\t", $_, $acc, $total, ($F[$col]/$total)*100 
	}' -- -total=$total -col=$2 $1 

else

	usage "file col"
fi

 

