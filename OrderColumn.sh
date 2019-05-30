#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

		perl -F'\t' -anle'
		BEGIN{
			$c=0;
		} 
		if(@ARGV){
			$h{$_}=$c++;
		}else{ 
			if(++$l==1){ 
			@order= @h{@F};
			}

			@line=();
			map { $line[$order[$_]]=$F[$_] } 0..$#F;
			print join "\t", @line;
			
		}' $1 $2
		#header CCP.filter.h.vcf.num | less
else
		usage "Reordered_Column_File Target_File"
fi
