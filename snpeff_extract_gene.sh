#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_3Q/
snpeff="java -Xmx32g -jar $SNPEFF_DIR/snpEff.jar"
snpsift="java -Xmx512g -jar $SNPEFF_DIR/SnpSift.jar"


if [ -f "$1" ] & [ $# -eq 2 ] ; then
	
	string="( ANN[*].GENE = '$2' )"
#echo $string
#cat $1 | $snpsift filter "( EFF[*].GENE = 'WASH7P' )"  >  $2.vcf
	cat $1 | $snpsift filter "$string" >  $2.vcf
	
else

	echo -e "\n\n${RED}use in denovo server${NORM}"
	usage "XXX.VCF GeneSymbol"
fi



