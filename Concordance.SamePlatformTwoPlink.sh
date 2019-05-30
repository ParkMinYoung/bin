#!/bin/sh
. ~/.bash_function


A=$1
B=$2



/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $A --bmerge $B.bed $B.bim $B.fam --merge-mode 7 --out blindTest --allow-no-sex --threads 5


PlinkOut2Tab.sh blindTest.diff


cut -f2 blindTest.diff.tab | sort | uniq -c | awk '{print $2"\t"$1}' > blindTest.diff.tab.count


/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $A --bmerge $B.bed $B.bim $B.fam --merge-mode 6 --out blindTest.missing --allow-no-sex --threads 5


PlinkOut2Tab.sh blindTest.missing.diff


perl -F'\t' -anle'if(/0\/0/){ $h{$F[1]} ++ } }{ map { print join "\t", $_, $h{$_} } sort keys %h'  blindTest.missing.diff.tab > blindTest.missing.diff.tab.NotCMPMarker

#join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep ^Axiom |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=789910 > Concordance


echo -e "CEL\tDiff\tNotCMPMarker\tTotalMarker\tConcordantRate" > Concordance
MARKER=$(wc -l one_batch_final.marker.bim  | awk '{print $1}')
join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep -v ^FID |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=$MARKER >> Concordance
# join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep ^Axiom |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=833535 >> Concordance

