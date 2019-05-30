#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then


		GATK_VCF=$1
		TRUE_VCF=$2
		DP=${3:-5}
		GQ=${4:-60}


#		echo $1 $2 $DP $GQ


		for i in $(vcf.sample.sh $GATK_VCF)
			do 
			vcftools.extract.sample.sh $GATK_VCF $i $DP $GQ
			GATK3.ValidationReport.VarTypeSplit.sh $i.recode.vcf $TRUE_VCF $i
		done

			

		# execute time : 2018-07-24 16:19:46 : 
		AddRow.w.sh ValidationReport './(.+)\/' ID $(find | grep -i validation.Summary$) | grep ^Add| sh 


		# execute time : 2018-07-24 16:23:07 : concordant rate
		AddRow.w.sh ConcordantRate './(.+)\/' ID  $(find | grep -i concordance.summary$) | grep ^Add | sh 

else

		usage "GATK_VCF TRUE_VCF DP[5] GQ[60]"
fi

