#!/bin/sh

source ~/.bash_function

if [ -f $1 ];then
	perl -MIO::Zlib -se'$fh=IO::Zlib->new($f,"r");
	while(<$fh>){
		chomp;$len+=length($_) if ++$c%4==0
	}print "$f\t$len\n"' -- -f=$1 > $1.SumOfSeqs
else
	usage try.gz
fi
