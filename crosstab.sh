#!/bin/bash

. ~/.bash_function

if [ $# -eq 3 ] && [ -f "$1" ];then
	
	perl -F'\t' -asnle'BEGIN{$r--;$c--} print join "\t", @F[$r,$c]' -- -r=$2 -c=$3 $1 | crosstab -r '$1' -c '$2' -d 'count($2)' 

elif [ $# -eq 5 ] && [ -f "$1" ];then

	cmd="$5(\$3)"	
#echo $cmd
	perl -F'\t' -asnle'BEGIN{$r--;$c--;$v--} print join "\t", @F[$r,$c,$v]' -- -r=$2 -c=$3 -v=$4 $1 | crosstab -r '$1' -c '$2' -d "$cmd"

else

cat <<EOF

Cross-tabulate column 4 (as rows) vs. column 7 (as columns), 
and sum the values from column 9:
$ crosstab -r '$4' -c '$7' -d 'sum($9)' INPUT > OUTPUT

Cross-tabulate column 5 (groupped into 'windows' of 1000) vs. column 7,
and show the average value from column 9:
$ crosstab -r 'floor($5/1000)*1000' -c '$7' -d 'average($9)' INPUT > OUTPUT

EOF


	usage "Table Row Col [Value] [Fucntion:sum, count, average, min, max]"
fi

