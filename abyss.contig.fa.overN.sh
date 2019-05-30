#!/bin/sh

source ~/.bash_function


IL=$2
L=${IL:=100}

if [ $# -eq 2 ] && [ -f "$1" ];then
	perl -snle'push @l,$_;if($.%2==0){print join "\n",@l if length($_) >=$l;@l=()}' -- -l=$L $1 > $1.over$L.fa
else
	usage "contig.fa [length:100]"
fi



