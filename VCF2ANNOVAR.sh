#!/bin/sh

. ~/.bash_function
. ~/.perl

BIN=/home/adminrig/src/ANNOVAR/annovar
HUMANDB=$BIN/humandb.hg19

summarize=$BIN/summarize_annovar.pl
reduction=$BIN/variants_reduction.pl
convert=$BIN/convert2annovar.pl


if [ -f "$1" ];then
	
	INPUT=$1

	ABS=$(fullpath $INPUT)
	NAME=$(basename $ABS)
	DIR="Annotation/$NAME"

	if [ ! -d $DIR ];then
		mkdir -p $DIR
	fi
	
	echo "`date` START $ABS";

	ln $ABS $DIR
	cd $DIR
	
	INPUT=$NAME

	(head -10000 $INPUT | grep ^#; perl -F'\t' -anle'print if /PASS/ && length $F[4] < 20 && $F[3] !~ /N/ && $F[4] !~ /N/ ' $INPUT) > $INPUT.PASS.vcf
#!!! cp $INPUT  $INPUT.PASS.vcf
	
	vcf2GT.sh $INPUT.PASS.vcf > $INPUT.PASS.vcf.GT

	$convert $INPUT.PASS.vcf -format vcf4 > $INPUT.PASS.vcf.annovar 2> $INPUT.PASS.vcf.annovar.log
	$summarize $INPUT.PASS.vcf.annovar $HUMANDB -outfile $INPUT.PASS.vcf.annovar.annotate -buildver hg19 --verdbsnp 138 --ver1000g 1000g2012apr --veresp 6500 --genetype refgene --noalltranscript --remove >& summarize_annovar.pl.log  

	#./variants_reduction.pl $INPUT.PASS.vcf.annovar humandb.hg19 -buildver hg19 -protocol nonsyn_splicing,genomicSuperDups,1000g2012apr_asn,esp6500_ea,esp6500_aa,snp135NonFlagged,cg69,ljb_sift,ljb_pp2,dominant -operation g,r,f,f,f,f,f,f,f,m -out reduce -maf_threshold 0.01 -ljb_sift_threshold 0.95 -ljb_pp2_threshold 0.85 (-genetype knowngene)

	$reduction $INPUT.PASS.vcf.annovar $HUMANDB -buildver hg19 -protocol nonsyn_splicing,genomicSuperDups,1000g2012apr_all,esp6500_ea,esp6500_aa,cg69,snp135NonFlagged,ljb_sift,ljb_pp2,dominant -operation g,r,f,f,f,f,f,f,f,m -out ASN -maf_threshold 0.01 -ljb_sift_threshold 0.95 -ljb_pp2_threshold 0.85 >& variants_reduction.pl.log 
	 wc -l `ls -tr *varlist ` > filter.count
	 grep ^# -v -c `ls -tr *vcf`  > VCF.Lines


	 ANNOVAR.csv2table.sh  $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv
	(head -1 $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table; egrep "(stopgain|stoploss|frameshift|nonsynonymous)" $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table ) > $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top
	perl -F'\t' -anle'$ori="$F[10]:$F[11]-$F[12]";if(/insertion/){print join "\t", @F[10..12],$ori}elsif(/deletion/){$F[11]--;print join "\t",  @F[10..12],$ori}else{print join "\t", @F[10..12],$ori}'  $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top >  $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top.bed

	 perl -F'\t' -anle'$ori="$F[10]:$F[11]-$F[12]";if(/insertion/){print join "\t", $ori, $F[10],$F[11]}elsif(/deletion/){$F[11]--;print join "\t", "$F[10]:$F[11]-$F[12]",$F[10],$F[11]}else{print join "\t", $ori,$F[10],$F[11]}' $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top > $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top.target

	 cut -f1 $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top.target > $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top.intervals


	 ANNOVAR.csv2table.sh $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv
	(head -1 $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table; egrep "(stopgain|stoploss|frameshift|nonsynonymous)"  $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table ) >  $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table.top
	 
	perl -F'\t' -anle'$ori="$F[10]:$F[11]-$F[12]";if(/insertion/){print join "\t", $ori, $F[10],$F[11]}elsif(/deletion/){$F[11]--;print join "\t", "$F[10]:$F[11]-$F[12]",$F[10],$F[11]}else{print join "\t", $ori,$F[10],$F[11]}' $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table.top > $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table.top.target


	 cut -f1 $INPUT.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table.top.target > $INPUT.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table.top.intervals

else
	usage "XXX.vcf"		
fi
 # step 1. exon, splicing variants
 # step 2. filter out genomic super duplicates region 
 # step 3. filter out 1000g2012apr_all(AMR(american),ASN(asian),EUR(european)) alt freq. > 0.01 
 # step 4. filter out esp6500_ea(EA[Euro Ameriacan]) alt freq. > 0.01
 # step 5. filter out esp6500_aa(AA[Africa Ameriacan]) alt freq. > 0.01
 # step 6. filter out cp69 alt freq. > 0.01
 # step 7. filter out not flagged sNPs(snp135NonFlagged)
 # step 8. filter out ljb_sift < 0.95
 # step 9. filter out ljb_pp2  < 0.85
 # step10. select dominant disease model


# NHLBI-ESP project with 6500 exomes : esp6500 
# Complete Genome 69 : cp69 (a diversity panel representing 9 different populations, a Yoruba trio; a Puerto Rican trio; a 17-member, 3-generation pedigree)
# NonFlagged : dbSNP with ANNOVAR index files, after removing those flagged SNPs (SNPs < 1% minor allele frequency (MAF) (or unknown), mapping only once to reference assembly, flagged in dbSnp as "clinically associated")

# phastConsElements44way r
# dgv r
# gwasCatalog r

