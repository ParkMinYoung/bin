perl -F'\t' -anle'BEGIN{print join ",", qw/Lane Sample Index Inst./} $F[7]=~/(SI-\w{2}-\w{2})/; $F[7]=$1; print join ",", @F[5,6,7,14]' run.*min.txt > X10.all.csv.bak
(head -1 X10.all.csv.bak; tail -n +2 X10.all.csv.bak | sort | uniq) > X10.all.csv

rm -rf X10.all.csv.bak

