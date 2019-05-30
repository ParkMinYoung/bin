ls *qseq.txt | perl -nle'$c=$_;s/s_(\d)_1_(\d{4})/s_$1_2_$2/;`ln -s $c $_`'
#find $PWD/00? -type f -name "*qseq.txt"  | perl -nle'$c=$_;s/s_(\d)_1_(\d{4})/s_$1_2_$2/;`ln -s $c $_`'
