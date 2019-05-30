#!/bin/sh

source ~/.bash_function
source ~/.GATKrc


perl -F'\t' -anle'

$num = ++$c{$ARGV};

if ( $num == 1 ){
	$ARGV =~ /.+\/(.+?)_\w{6,7}_L00\d+/;

	if ( ! defined $h{0} ){
		push @{ $h{0} }, "Desc", $1;
	}else{
		push @{ $h{0} }, $1;
	}
}

if ( keys %c == 1 ){
	push @{ $h{$num} }, $F[0],$F[1];
}else{
	push @{ $h{$num} }, $F[1];
}

}{
	map { print join "\t", @{ $h{$_} } } sort {$a<=>$b} keys %h;
' `find | grep StatisticsReport$ | sort` > StatisticsReport.summary.txt
	
	

