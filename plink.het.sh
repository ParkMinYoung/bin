PLINK=$1
~/src/PLINK/plink-1.09-x86_64/plink --bfile $PLINK --het --out $PLINK --allow-no-sex
PlinkOut2Tab.sh $PLINK.het

perl -F'\t' -anle'if(@ARGV){@F=split /\s+/, $_; $h{$F[0]}=$F[4] }else{ if($c++ > 1){ $het = ($F[4]-$F[2])/$F[4];print join "\t", $F[0], $h{$F[0]}, $het }}' $PLINK.fam $PLINK.het.tab > $PLINK.het.tab.out


