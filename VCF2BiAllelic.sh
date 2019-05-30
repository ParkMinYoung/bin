# https://www.biostars.org/p/141156/
bcftools view -M2 -m2 $1 > ${1%.vcf}.BiAllelic.vcf
