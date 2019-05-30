perl -F'\t' -MMin -alne'$h{$F[11]}++;$h{Total}++}{h1c(%h)' snp132.txt > snp132.txt.type.count
perl -F'\t' -anle'print join "\t", @F[1..3], (join ";",@F[4..$#F])' snp132.txt > snp132.txt.bed &
grep single snp132.txt.bed > snp132.txt.single.bed

