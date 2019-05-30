#!/bin/sh

EXT=$(perl -sle'$f=~/\.(\w+)?$/;print $1' -- -f=$1)
if [ $EXT == "gz" ];then
	zcat $1 | sed -n 1~4p | cut -d" " -f2 | cut -c1-5 | sort | uniq -c | awk  '{print $2,"\t",$1}' >  $1.headercount
else
	sed -n 1~4p $1 | cut -d" " -f2 | cut -c1-5 | sort | uniq -c | awk  '{print $2,"\t",$1}' >  $1.headercount
fi

