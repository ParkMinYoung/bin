#!/bin/sh

. ~/.bash_function



input_type=$(show_input_type)

#echo $input_type
#echo $@


if [ $input_type == "STDIN" ] && [ ! -f "$4" ]  ;then
	
	usage "ColumnNumber_Row ColumnNumber_Col ColumnNumber_Val Input"

elif [ $# -lt 3 ];then

	usage "ColumnNumber_Row ColumnNumber_Col ColumnNumber_Val Input"

else

#	[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"

	input="${4:-/dev/stdin}"
	cat $input | _ColCol2Matrix.sh $1 $2 $3  

fi

