#!/bin/sh 
source ~/.bash_function

if [ $# -ge 1 ];then

perl -MFile::Basename -le'
map{($file,$dir)=fileparse($_);$h{$dir}++} @ARGV; 
END{print "@{[sort keys %h]}"}' $@

else
	usage "file list"
fi

