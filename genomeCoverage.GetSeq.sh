#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

if [ -f "$1" ];then

perl -F'\t' -anle'
if($F[0] =~ /^(chr)?(\d+|X|Y)/ &&  $F[1]){
	$seq+=$F[1]*$F[2];
}
}{ print $seq' $1 

else
	usage "xxxx.genomeCoverage"
fi

