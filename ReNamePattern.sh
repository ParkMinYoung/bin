#!/bin/sh
. ~/.bash_function

if [ $# -ge 2 ];then

	PATTERN=$1
	shift
	ls $@ | perl -snle'$c=$_; $_=~s/$pattern//; print "mv $c $_"' -- -pattern=$PATTERN 

else
	usage "PATTERN XXX YYY ZZZ....."
fi


