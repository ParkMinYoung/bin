#!/bin/bash

. ~/.bash_function

#/home/adminrig/src/ngs-analysis/modules/variant/gatk3.selectvariants.sh /home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta  PDX.43.analysisready.pass.vcf  SPX0_100.vcf "--setFilteredGtToNocall --selectTypeToExclude NO_VARIATION -sn SPX0_100"  

if [ $# -eq 3 ] && [ -f "$1" ] && [ -f "$2" ] ;then

	/home/adminrig/src/ngs-analysis/modules/variant/gatk3.selectvariants.sh /home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta $1 $3 "--setFilteredGtToNocall --selectTypeToExclude NO_VARIATION -sf $2"  

else	
	echo -e "\n\n$0 904.selectsample.snpeff.dbNSFP.vcf SP100 SP100.vcf\n\n"

	usage "VCF SampleList Output_VCF"
fi


