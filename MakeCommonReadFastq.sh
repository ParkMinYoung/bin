#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ];then
	
	perl -nle'chop && $h{$_}++ if $.%4==1 }{ map { print if $h{$_}==2 } keys %h' $1 $2 > common.read
	perl -nle'if(@ARGV){$h{$_}++}else{push @l,$_; if(++$c%4==0){$t=$l[0];chop $t; print join "\n",@l if $h{$t};@l=()}}' common.read $1 > $1.common.fastq
	perl -nle'if(@ARGV){$h{$_}++}else{push @l,$_; if(++$c%4==0){$t=$l[0];chop $t; print join "\n",@l if $h{$t};@l=()}}' common.read $2 > $2.common.fastq

	wc -l common.read $1.common.fastq $2.common.fastq > common.read.len
else
	usage fastq1 fastq2
fi
