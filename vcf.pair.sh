VCFTOOLS=/home/adminrig/src/vcf-tools/vcftools_0.1.9/bin/vcftools

F1=$(basename $1 .vcf)
F2=$(basename $2 .vcf)

DIR=$F1-$F2
mkdir $DIR

ABS_F1=$(readlink -f $1)
ABS_F2=$(readlink -f $2)


cd $DIR

cp $ABS_F1 ./
cp $ABS_F2 ./

perl -i.bak -ple's/FORMAT\t.+$/FORMAT\tA/ if /^#CHR/' *vcf 

#$VCFTOOLS --vcf $1 --diff $2 --diff-discordance-matrix --diff-site-discordance --remove-indels --remove-filtered LowQual --maxDP 10000 --out $OUT
$VCFTOOLS --vcf $1 --diff $2 --diff-discordance-matrix --diff-site-discordance --diff-indv-discordance --remove-indels --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNP.DP10GQ90
$VCFTOOLS --vcf $1 --diff $2 --diff-discordance-matrix --diff-site-discordance --diff-indv-discordance --keep-only-indels  --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out INDEL.DP10GQ90
$VCFTOOLS --vcf $1 --diff $2 --diff-discordance-matrix --diff-site-discordance --diff-indv-discordance --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90 

