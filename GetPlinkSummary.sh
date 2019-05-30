#!/bin/sh

. ~/.bash_function

if [ $# > 0 ]; then


	echo $@ | tr " " "\n" | \
	perl -MMin -nle' $m=`wc -l < $_.bim`; chomp($m);$h{$_}{Marker}=$m; $s=`wc -l < $_.fam`; chomp($s); $h{$_}{Sample}=$s }{ mmfss_n("SampleMarker", %h)' 


else
	echo "find -maxdepth 2 | grep FinalQC.bim$ | sed \'s/.bim//\'"
	usage "Plink Names..."
fi


