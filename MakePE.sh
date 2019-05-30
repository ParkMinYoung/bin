ls *qseq.txt | perl -nle'$c=$_;s/1_(\d{4})/2_$1/;`ln -s $c $_`'
