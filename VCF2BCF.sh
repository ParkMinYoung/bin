VCF=$1
# excute time : 2017-12-05 11:32:03 : gzvcf
vcf2tabix.sh $VCF


# excute time : 2017-12-05 11:32:29 : bcf
bcftools view -O b $VCF.gz -o ${VCF%.vcf}.bcf 

