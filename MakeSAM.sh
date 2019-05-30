#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	perl -nle'next if /^cel/; s/\.\.\/\.\.\///; /.+_\d{6}_\w{2,3}_(.+)\.CEL/; $id=$1; $id =~ s/_(2|3|4)$//; print "$_\t$id"' $1

else

	usage "celfiles.txt"

fi

