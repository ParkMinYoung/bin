perl -F'\t' -anle'if($.>1 && $F[1]>3){ $dir="ClusterSignal/$F[1]"; mkdir("ClusterSignal/$F[1]") if ! -d $dir; `mv ClusterSignal/$F[0].png $dir` }' MismatchCountPerSNP.txt  

