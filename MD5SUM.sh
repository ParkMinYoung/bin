#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] ;then
	md5sum $1 > $1.md5sum
else
	usage "xxx.ext"
fi
