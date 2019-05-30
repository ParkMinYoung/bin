#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_3Q/
snpeff="java -Xmx32g -jar $SNPEFF_DIR/snpEff.jar"
snpsift="java -Xmx32g -jar $SNPEFF_DIR/SnpSift.jar"


if [ -f "$1" ]; then

	$snpsift extractFields $1  -s "," -e "." CHROM POS ID REF ALT ANN[*].EFFECT ANN[*].IMPACT ANN[*].GENE ANN[*].GENEID ANN[*].FEATURE ANN[*].FEATUREID ANN[*].BIOTYPE ANN[*].RANK ANN[*].HGVS_C ANN[*].HGVS_P ANN[*].CDNA_POS ANN[*].CDNA_LEN ANN[*].CDS_POS ANN[*].CDS_LEN ANN[*].AA_POS ANN[*].AA_LEN ANN[*].DISTANCE > $1.data
#	$snpsift extractFields $1  -s "," -e "." CHROM POS ID REF ALT  "ANN[*].GENE" "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" > $1.data

	snpeff_reheader.sh $1.data

	\mv -f $1.data.header $1.data
	cp /home/adminrig/Genome/1000Genomes/20130502/Annotation.snpeff/Annotation.Readme ./ 

else

	echo -e "\n\n${RED}annotated by snpEff_4_3Q${NORM}"
	usage "annotated.vcf"
fi



