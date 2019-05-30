#!/bin/sh

. ~/.bash_function
. ~/.perl

if [ -f "$1" ] ;then

perl -nle'
if(@ARGV && $ARGV =~ /sam$/){
	if(! /\@/){
		$h{ (split "\t", $_, 2)[0] } ++;
	}
}else{
	$c++;
	push @line, $_;
	if( $c%4==0 ){
		$read = $line[0];
		$read =~ s/^\@//;
		if( $h{ $read } ){
			print join "\n", @line;
		}
		@line = ();
	}
}
' $1.starAligned.out.sam $1 > $1.unmapped.fastq

else
	usage "XXX.fastq"
fi

