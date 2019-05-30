#!/bin/bash


. ~/.bash_function



if [ -f "$1" ] && [ -f "$2" ] && [ $# -eq 3 ];then

		
GATK_VCF=$(readlink -f $1)
TRUE_VCF=$(readlink -f $2)
DIR=$3

GATK_VCF_name=$(basename $1)
TRUE_VCF_name=$(basename $2)

VCF_all=${GATK_VCF_name%.vcf}.all.vcf
VCF_snp=${GATK_VCF_name%.vcf}.snp
VCF_indel=${GATK_VCF_name%.vcf}.indel


TRUE_VCF_all=${TRUE_VCF_name%.vcf}.all.vcf
TRUE_VCF_snp=${TRUE_VCF_name%.vcf}.snp
TRUE_VCF_indel=${TRUE_VCF_name%.vcf}.indel


		[ ! -d "$DIR" ] && mkdir $DIR

		cd $DIR


		## TRUESET split ##

		if [ ! -f "$TRUE_VCF_snp" ] && [ ! -f "$TRUE_VCF_indel" ];then
			

			# execute time : 2018-07-23 17:40:21 : 
			(grep ^# $GATK_VCF ; grep -v -e ^# -e ^X $TRUE_VCF | sort -n -k1,1 -k2,2; grep ^X $TRUE_VCF | sort -n -k2,2 )  > $TRUE_VCF_all

			
			# execute time : 2018-07-23 17:40:21 : rename
			perl -F'\t' -i -aple'if(/^#CHR/){$F[9]="NA12878";$_= join "\t", @F}' $TRUE_VCF_all


			# execute time : 2018-07-24 11:09:36 : only snp
			vcftools --vcf $TRUE_VCF_all --remove-indels --out $TRUE_VCF_snp --recode 

			
			# execute time : 2018-07-24 11:08:58 : only indel
			vcftools --vcf $TRUE_VCF_all --keep-only-indels --out $TRUE_VCF_indel --recode 



		fi


		## GATK split

		# execute time : 2018-07-24 09:48:45 : cleanup
		grep -v -e "\.\/\." -e "0\/0"  $GATK_VCF > $VCF_all


		# execute time : 2018-07-23 17:23:50 : rename 
		perl -F'\t' -i -aple'if(/^#CHR/){$F[9]="NA12878";$_= join "\t", @F}' $VCF_all


		# execute time : 2018-07-24 11:08:58 : only indel
		vcftools --vcf $VCF_all --keep-only-indels --out $VCF_indel --recode 


		# execute time : 2018-07-24 11:09:36 : only snp
		vcftools --vcf $VCF_all --remove-indels --out $VCF_snp --recode 


		## run : validationReport

		GATK3.ValidationReport.sh $VCF_all $TRUE_VCF_all $DIR.validation.all
		GATK3.ValidationReport.sh $VCF_snp.recode.vcf $TRUE_VCF_snp.recode.vcf $DIR.validation.snp
		GATK3.ValidationReport.sh $VCF_indel.recode.vcf $TRUE_VCF_indel.recode.vcf $DIR.validation.indel
		
		AddRow.w.sh $DIR.validation.Summary '(snp|indel|all).tab' VarType *validation.{all,snp,indel}.tab | grep ^Add | sh 

		
		## run : concordant rate
	
		REF=/home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta
		GATK3.genotypeconcordance.sh $REF $VCF_all $TRUE_VCF_all $DIR.concordance.all
		GATK3.genotypeconcordance.sh $REF $VCF_snp.recode.vcf $TRUE_VCF_snp.recode.vcf $DIR.concordance.snp 
		GATK3.genotypeconcordance.sh $REF $VCF_indel.recode.vcf $TRUE_VCF_indel.recode.vcf $DIR.concordance.indel

		AddRow.w.sh $DIR.concordance.Summary '(snp|indel|all).tab' ConcordantRate *concordance.{all,snp,indel}.tab | grep ^Add | sh 

else
		usage "GATK_VCF TRUE_VCF DIR_OUTPUT"
fi






