#!/bin/sh

. ~/.bash_function

if [ $# -eq 1 ];then

	ls *.CEL | perl -snle'$c=$_; s/Axiom_JJBC1SNP_(0\d{2})(\d{3})_/Axiom_JJBC1SNP_999${batch}_/; print "ln $c $_"' -- -batch=$1 | sh

else	
	usage "001[002,003]..."
fi



