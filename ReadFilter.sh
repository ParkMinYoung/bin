#!/bin/sh

source $HOME/.bash_function

if [ $# != 2 ];then
usage  FastqFile FilterCutNum
fi

perl -snle'push @t,$_;if($.%4==0 && ++$t && length $_ >= $len){print join "\n",@t;$p++;;} @t=() if $.%4==0 }{ print STDERR "all : $t pass: $p"' -- -len=$2 $1 > $1.ReadFilter
