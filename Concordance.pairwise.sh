compare.pairwise.sh $1 $2

F1=$(basename $1)
F2=$(basename $2)
simulation.pairwise.sh  $F1-$F2.Concordance.txt > $F1-$F2.simulation.out
