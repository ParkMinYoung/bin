


perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])==1 && length($F[4])==1){print}' $1 > $1.SNP.vcf
perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])==1 && length($F[4])>1){print}' $1 > $1.INSERT.vcf
perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])>1 && length($F[4])==1){print}' $1 > $1.DELET.vcf

perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])==1 && length($F[4])==1){print}' $2 > $2.SNP.vcf
perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])==1 && length($F[4])>1){print}' $2 > $2.INSERT.vcf
perl -F'\t' -anle'if(/^##/){print}elsif(s/FORMAT\t.+/FORMAT\tID/){print}elsif(!/^#/ && length($F[3])>1 && length($F[4])==1){print}' $2 > $2.DELET.vcf

VCFTOOLS=/home/adminrig/src/vcf-tools/vcftools_0.1.9/bin/vcftools

#vcftools --vcf $1.SNP.vcf --diff $2.SNP.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.SNP.concordance --remove-indels > /dev/null &
#vcftools --vcf $1.INSERT.vcf --diff $2.INSERT.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.INSERT.concordance --keep-only-indels  > /dev/null &
#vcftools --vcf $1.DELET.vcf --diff $2.DELET.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.DELET.concordance --keep-only-indels  > /dev/null &

$VCFTOOLS --vcf $1.SNP.vcf --diff $2.SNP.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.SNP.concordance > /dev/null 
$VCFTOOLS --vcf $1.INSERT.vcf --diff $2.INSERT.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.INSERT.concordance > /dev/null 
$VCFTOOLS --vcf $1.DELET.vcf --diff $2.DELET.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out $1.DELET.concordance > /dev/null 

DIR=$(dirname $1)
F1=$(basename $1)
F2=$(basename $2)

OUT=$DIR/$F1.$F2

vcftools.concordance.summary.sh $1.SNP.concordance.* > $OUT.SNP.concordance.summary
vcftools.concordance.summary.sh $1.INSERT.concordance.* > $OUT.INSERT.concordance.summary 2> /dev/null
vcftools.concordance.summary.sh $1.DELET.concordance.* > $OUT.DELET.concordance.summary 2> /dev/null


cat $OUT.SNP.concordance.summary  $OUT.INSERT.concordance.summary $OUT.DELET.concordance.summary > $OUT.concordance.summary


