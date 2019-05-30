java -Xmx16G -jar /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar eff  GRCh37.75 $1 > $1.eff.vcf
java -jar /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar annotate -v /home/adminrig/Genome/Clinvar/clinvar_20161003.vcf.gz $1.eff.vcf > $1.eff.clinvar.vcf
 
 
# excute time : 2016-11-03 14:47:19 : get pathogenic
perl -nle'print if /^#/; if(/CLNSIG=(.+?);/){$sig=$1; $sig=~s/255//g; print if $sig=~/5|6|7/ }' $1.eff.clinvar.vcf > $1.eff.clinvar.CLNSIG_Pathogenic.vcf
 















## Garbage 20170926

# excute time : 2016-11-17 19:03:05 : extractFields
#v1.java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_2/SnpSift.jar extractFields $1.eff.clinvar.vcf CHROM POS ID REF ALT AF DP RO AO SRF SRR SAF SAR TYPE CLNACC CLNDBN OM SAO MUT CLNDSDB CLNHGVS CLNORIGIN CLNSIG GENEINFO > $1.eff.clinvar.vcf.tab 
#java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_2/SnpSift.jar extractFields -s "," -e "." $1.eff.clinvar.vcf CHROM POS ID REF ALT AF DP RO AO "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" SRF SRR SAF SAR TYPE CLNACC CLNDBN OM SAO MUT CLNDSDB CLNHGVS CLNORIGIN CLNSIG GENEINFO > $1.eff.clinvar.vcf.tab
#java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_2/SnpSift.jar extractFields -s "," -e "." $1.eff.clinvar.vcf CHROM POS ID REF ALT AF DP GEN[0].AD[0] GEN[0].AD[1] "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" CLNACC CLNDBN OM SAO MUT CLNDSDB CLNHGVS CLNORIGIN CLNSIG GENEINFO > $1.eff.clinvar.vcf.tab

# excute time : 2016-11-17 19:03:47 : get BRCA
#(head -1 $1.eff.clinvar.vcf.tab; grep BRCA $1.eff.clinvar.vcf.tab) > $1.eff.clinvar.vcf.tab.BRCA


