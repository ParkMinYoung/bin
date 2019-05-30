#!/bin/bash

. ~/.bash_function


if [ $# -eq 3 ] ;then

		R_num=$(($1-1)) ## row header col
		C_num=$(($2-1)) ## column col
		V_num=$(($3-1)) ## value col

		cat - | \
		perl -F'\t' -MMin -asne'
		chomp@F;
		if($.>1){
				$h{$F[$row]}{$F[$col]} = $F[$value]
		}
		}{ 
		show_matrix(%h)
		' -- -row=$R_num -col=$C_num -value=$V_num 

else
		usage "ColumnNumber_Row ColumnNumber_Col ColumnNumber_Val"
fi


