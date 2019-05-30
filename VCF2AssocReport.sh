#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] ;then


SIFT=/home/adminrig/src/SNPEFF/snpEff_3_2/SnpSift.jar


VCF=$1
TFAM=$2
Project=${VCF/%.vcf/}


head -10000 $VCF | grep ^#CHROM | cut -f10- | tr "\t" "\n" > $VCF.IDs

if [ ! -f "$TFAM" ];then
	perl -F'\t' -nle'print join "\t", $_,$_,0,0,1,1' $VCF.IDs > $VCF.IDs.tfam

	## tfam format
	# 1 Family ID XXX
	# 2 Sample ID XXX
	# 3 Father ID 0
	# 4 Mother ID 0
	# 5 Gender ID 1 or 2 
	# 6 Affection_Status : Case 2, Control 1, unkonwn 0

else


	# no apply
	# vcftools --vcf $VCF --keep $VCF.IDs --remove-filtered-all --minGQ 20 --minDP 10 --maxDP 10000 --maf 0.00000001 --geno 0.9 --out $VCF.QC --recode

	# check the allele count per site
	# vcftools --vcf $VCF.QC.recode.vcf --freq --counts 
	# vcftools --vcf $VCF --keep $VCF.IDs --remove-filtered-all --maf 0.00000001 --geno 0.9 --out $VCF.QC --recode

	vcftools --vcf $VCF --keep $VCF.IDs --remove-filtered-all --minGQ 20 --minDP 10 --maxDP 10000 --out $VCF.QC --recode
	vcftools --vcf $VCF.QC.recode.vcf --maf 0.00000001 --geno 0.9 --out $VCF.QC.Site --recode
	#vcftools --vcf $VCF.DP.Site.recode.vcf --freq --counts 


	# case 14 : control 125
	#java -jar $SIFT caseControl "++++++++++++-----------------------------------------------------------------------------------------------------------------------------" $VCF.QC.Site.recode.vcf > $VCF.QC.Site.recode.vcf.assoc.vcf
	java -jar $SIFT caseControl  -tfam $TFAM $VCF.QC.Site.recode.vcf > $VCF.QC.Site.recode.vcf.assoc.vcf

	#perl -nle'BEGIN{print "##phe1,Integer,0,\"CaseControl\"\n#ID\tphe1"} print "$_\t1"' $VCF.IDs > $VCF.IDs.phe
	perl -F'\t' -anle'BEGIN{print "##phe1,Integer,0,\"CaseControl\"\n#ID\tphe1"} print "$F[1]\t$F[5]"' $TFAM > $VCF.IDs.phe

	pseq $Project new-project
	pseq $Project load-vcf --vcf $VCF.QC.Site.recode.vcf
	pseq $Project load-pheno --file $VCF.IDs.phe
	pseq $Project v-assoc --phenotype phe1 | gcol VAR REF ALT MAF HWE MINA MINU OBSA OBSU REFA HETA HOMA REFU HETU HOMU P OR PDOM ORDOM PREC ORREC > $Project.assoc

#perl -F'\t' -anle'if($.==1){print}elsif($F[15] <= 0.05 || $F[17] <= 0.05 || $F[19] <= 0.05){print}' $Project.assoc > $Project.assoc.Pvalue0.05
#perl -F'\t' -anle'if(@ARGV){/chr(\w+:\d+)/; $h{$1}++}elsif(/^#/){print}elsif($h{"$F[0]:$F[1]"}){print}' $Project.assoc.Pvalue0.05 $VCF.QC.Site.recode.vcf > $VCF.QC.Site.recode.vcf.Pvalue.vcf

	perl -F'\t' -anle'if($.==1){print}elsif($F[15] <= 0.05 || $F[17] <= 0.05 || $F[19] <= 0.05){print}' $Project.assoc > $Project.assoc.Pvalue0.05
	perl -F'\t' -anle'if(@ARGV){/chr(\w+:\d+)/; $h{$1}++}elsif(/^#/){print}elsif($h{"$F[0]:$F[1]"}){print}' $Project.assoc $VCF.QC.Site.recode.vcf > $VCF.QC.Site.recode.vcf.Pvalue.vcf
	
	VCF2ANNOVAR.sh $VCF.QC.Site.recode.vcf.Pvalue.vcf


	Link2Pseq.ANNOVAR.sh Annotation/$VCF.QC.Site.recode.vcf.Pvalue.vcf/$VCF.QC.Site.recode.vcf.Pvalue.vcf.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table $Project.assoc
	Link2Pseq.ANNOVAR.sh Annotation/$VCF.QC.Site.recode.vcf.Pvalue.vcf/$VCF.QC.Site.recode.vcf.Pvalue.vcf.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table $Project.assoc.Pvalue0.05
	
	 grep -i $Project.assoc.Pvalue0.05.Report | cut -f22 | sort | uniq | tr "," "\n"  | tr ";" "\n" | grep -v "NM_" > $Project.assoc.Pvalue0.05.Report.Genes
fi


else
	usage "XXX.vcf [YYY.tfam]" 
fi

