#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

	AxiomCSV2TAB.sh $1
	AxiomLibTAB2BED.sh $1.tab 


	perl -F'\t' -anle'$k=join ":", @F[4,6,13,14]; push @{ $h{$k} }, $F[0] }{ map { print join "\t", $_, @{ $h{$_} } if @{ $h{$_} } > 1 } keys %h' $1.tab > $1.tab.DuplicatesMarker
	#paste <(cut -f2 $1.tab.DuplicatesMarker  | cut -c1-2) <(cut -f3 $1.tab.DuplicatesMarker | cut -c1-2) | sort | uniq -c 

	# excute time : 2016-12-05 11:45:18 : get unique markers
		# modify 20180130 end position[6]->start position[5]
		# in @F[4,5,13,14]
	perl -F'\t' -anle'$k=join ":", @F[4,5,13,14]; print $F[0] if !$h{$k}++' $1.tab > $1.tab.unique.Marker
else
	usage "Axiom_KORV1_1.csv"
fi



