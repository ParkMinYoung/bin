#!/bin/sh

source ~/.bash_function 

# set5.A8004.R1.ACAGTG.L005.txt


if [ -f "$1" ] ;then


perl -F'\t' -MMin -MPDL -asne'
chomp@F;
if($.==1){
	shift @F;
	for $i (@F){
		$i=~/\.(R\d)\./;
		$read=$1;
		++$c;
	map { $id="$_-$read";push @{$h{$id}}, $c } split /\./, $i;
	}
#	map { print "$_\t@{ [@{$h{$_}}+0] }\t@{$h{$_}}" } sort keys %h
}elsif(/^\d+/){
	$base=$F[0];
	
	for $group ( sort keys %h ){
		@index = @{$h{$group}};
		$data = pdl (@F[@index]); 
		$matrix{$base}{$group}= sprintf "%0.2f", avg($data);
	}
}

}{ mmfsn("$file-grouping",%matrix);

' -- -file="$1" "$1"

else
	usage "Per\ base\ sequence\ quality.txt"
fi

