#!/bin/sh

if [ $# -eq 0 ];then
	find -maxdepth 1 -type f | xargs ls -lt | perl -nle'$n=sprintf "%2d", ++$c; print "$n $_"'
else
	find -maxdepth 1 -type f | xargs ls -t | 
	perl -snle'
	BEGIN{
		($s,$e)=split "-",$s;
		@list= $e ? ($s..$e) : $s;
		@ok{@list}=(1)x(@list+0);
#print "$s,$e";
#map { print "$_ $ok{$_}" } sort keys %ok;
	} 
	if($ok{++$c}){
		print;
	}' -- -s=$1 
fi

