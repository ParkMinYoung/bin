#!/bin/sh

. ~/.bash_function

# usage :  Cols2Matrix.sh row_col_num value_col_num file_name `find | grep stats.txt$` 

if [ $# -gt "4" ];then

# column number of target file
R_num=$(($1-1)) ## row header col
C_num=$(($2-1)) ## value col
V_num=$(($3-1)) ## value col

# created file name
TITLE=$4

shift
shift
shift 
shift

# $@ : target file

perl -F'\t' -MMin -asne'
chomp@F;
if($.>1){
	$h{$F[$row]}{$F[$col]} = $F[$value]
}
}{ mmfss_blank($title, %h)
#}{ mmfsn($title, %h)
' -- -row=$R_num -col=$C_num -value=$V_num -title=$TITLE $@

else
	usage "row_num col_num value_num file_name file "
fi

