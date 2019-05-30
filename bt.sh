#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then

		perl -F'\t' -anle'
		if(@ARGV){
			$h{$_}++
		}elsif($h{$F[4]}){
			print; 
			$c++;
		}
		}{ print STDERR "output : $c"' $1 $2  > $1.dbsnp

else
		usage "rs_list_file dbsnp132.txt"
fi

