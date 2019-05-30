#!/bin/bash

. ~/.bash_function

if [ $# -ge 2 ] && [ -f "$1" ] ;then

INPUT="$1"
KEYS="$2"
LABEL=${3:-"key"}
DELIM=${4:-":"}

perl -F"\t" -MMin -aslne'
BEGIN{
		@key=args2list($keys);
}

$add_value = $.==1 ? $label : join "$delim", @F[@key];
print join "\t", $_, $add_value;
' -- -keys="$KEYS" -label=$LABEL -delim=$DELIM $INPUT

else

	usage "File key_columns(1,2,3) label[key] delim[:]"

fi

