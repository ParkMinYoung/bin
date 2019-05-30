VCF=$1
vcftools --vcf $VCF --remove-filtered-all --minGQ 20 --minDP 10 --maxDP 10000 --out $VCF.QC --recode
vcftools --vcf $VCF.QC.recode.vcf --maf 0.00000001 --geno 0.9 --out $VCF.QC.Site --recode

