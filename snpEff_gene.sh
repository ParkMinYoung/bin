perl -F'\t' -MList::Util=sum -anle'print if !/^ENS/; print if sum @F[27..37];' snpEff_genes.txt
