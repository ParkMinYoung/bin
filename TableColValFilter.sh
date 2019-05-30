#!/bin/sh

. ~/.bash_function

if [ $# -eq 3 ] && [ -f $3 ];
then

COL=$1
VAL=$2
F=$3
perl -F'\t' -ansle'

BEGIN{
$col--
}

if($.==1){
    print
}elsif( $F[$col] >= $value ){
    print
}' -- -col=$COL -value=$VAL $F


else
	usage "3[column] 0.9[value] Table"
fi

