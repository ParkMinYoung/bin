#!/bin/sh

perl -le'
map{/\.(\w+)$/;push @{$h{$1}},$_} @ARGV ; 

for $i (@ARGV){
	if( -f $i && /\.(\w+)$/){
		push @{$h{$1}},$_
	}
}
END{ 
	map { 
		mkdir $_ if ! -d $_; 
		`mv @{$h{$_}} $_`
	} sort keys %h 
}' $@

