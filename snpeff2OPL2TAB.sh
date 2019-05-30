#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_2/
SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_3Q/
snpsift="java -Xmx512g -jar $SNPEFF_DIR/SnpSift.jar"
#snpsift="java -Xmx512g -jar /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar"


if [ -f "$1" ]; then

	cat $1 | \
	$SNPEFF_DIR/scripts/vcfEffOnePerLine.pl | \
	$snpsift extractFields  -s "," -e "." - CHROM POS ID REF ALT ANN[*].EFFECT ANN[*].IMPACT ANN[*].GENE ANN[*].GENEID ANN[*].FEATURE ANN[*].FEATUREID ANN[*].BIOTYPE ANN[*].RANK ANN[*].HGVS_C ANN[*].HGVS_P ANN[*].CDNA_POS ANN[*].CDNA_LEN ANN[*].CDS_POS ANN[*].CDS_LEN ANN[*].AA_POS ANN[*].AA_LEN ANN[*].DISTANCE > $1.tab

else
	
	usage "snpeff.vcf[ANN]"

fi

