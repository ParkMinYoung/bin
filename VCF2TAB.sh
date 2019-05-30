

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_2/
snpsift="java -Xmx512g -jar $SNPEFF_DIR/SnpSift.jar"

cat $1 | $snpsift extractFields -s "," -e "." - CHROM POS ID REF ALT AC AF DP VARTYPE "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" GEN[0].GT GEN[0].DP GEN[0].AD > $1.tab



