#!/bin/sh
. ~/.bash_function

if [ $# -ge 2 ];then

	PATTERN1=$1
	shift
	PATTERN2=$1
	shift

	ls $@ | perl -snle'$c=$_; $_=~s/$pattern1/$pattern2/; print "ln -s $c $_"' -- -pattern1=$PATTERN1 -pattern2=$PATTERN2

else
	usage "PATTERN1 PATTERN2 XXX YYY ZZZ....."
fi


