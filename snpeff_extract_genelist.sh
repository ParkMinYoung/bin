#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_2/
snpeff="java -Xmx32g -jar $SNPEFF_DIR/snpEff.jar"
snpsift="java -Xmx512g -jar $SNPEFF_DIR/SnpSift.jar"


if [ -f "$1" ] & [ $# -eq 2 ] ; then
	
#echo $string
#cat $1 | $snpsift filter "( EFF[*].GENE = 'WASH7P' )"  >  $2.vcf
	
	for i in $(cat $2); 
	do 
		string="( ANN[*].GENE = '$i' )"
		cat $1 | $snpsift filter "$string" > $i.vcf
	done 
	
else

	usage "XXX.VCF GeneList"
fi



