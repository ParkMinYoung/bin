#!/bin/sh

. ~/.bash_function


LEN=15
SEP=${2:-$LEN}

input_type=$(show_input_type)

#echo $input_type
#echo $1

if [ $input_type == "STDIN" ] && [ ! -f "$1" ]  ;then
	
	usage "FILE_or_stdin [string length:15]"

else

#	[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"

	input="${1:-/dev/stdin}"
	cat $input | perl -F'\t' -asnle'$str= sprintf "%${len}s" x @F, @F; print $str' -- -len=$SEP
	
fi

