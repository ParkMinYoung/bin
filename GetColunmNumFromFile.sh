#!/bin/sh 


. ~/.bash_function

if [ -f "$1" ] ; then

perl -F'\t' -MList::Util=max -anle'
$h{@F+0}++
}{
#print join ",", keys %h;
print max ( keys %h )' $1

else
	usage "XXX"
fi

