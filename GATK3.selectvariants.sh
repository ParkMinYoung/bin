#!/bin/bash

. ~/.bash_function

#/home/adminrig/src/ngs-analysis/modules/variant/gatk3.selectvariants.sh /home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta  PDX.43.analysisready.pass.vcf  SPX0_100.vcf "--setFilteredGtToNocall --selectTypeToExclude NO_VARIATION -sn SPX0_100"  

if [ $# -eq 2 ] & [ -f "$1" ];then
	/home/adminrig/src/ngs-analysis/modules/variant/gatk3.selectvariants.sh /home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta $1 $2.vcf "--setFilteredGtToNocall --selectTypeToExclude NO_VARIATION -sn $2"  

else	
	usage "VCF SampleID"
fi


