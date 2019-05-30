#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then


perl -F'\t' -anle'
if(@ARGV){
    $k="chr$F[0]:$F[1]:$F[2]";
    $v=join "\t", @F[3..$#F];
    $h{$k}=$v;
	$header = $v if $.==1;
}elsif(/^VAR/){
    print join "\t", $_, $header; 
}elsif($h{$F[0]}){
    print "$_\t$h{$F[0]}";
}elsif($F[0]=~/(\w+):(\d+)\.\.(\d+):(.+)/){
	$k1="$1:$2:$4";
	$k2="$1:$3:$4";

	$h{$k1} ? 
			print "$_\t$h{$k1}":
			print "$_\t$h{$k2}";
}else{
	print ">>>>$_";
}

' $1 $2 > $2.SNPEFF.annotation
#000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.SelectVariants.SNP.vcf.VariantFiltration.vcf.ApplyRecalibration.vcf.CombineVariants.vcf.GRCh37.63.vcf.SNPEFF.parsing.uniq CAD.FinalVCF.p100vs130.assoc.Pvalue0.05

else
	usage "XXXX..vcf.GRCh37.63.vcf.SNPEFF.parsing.uniq(Eff.parsing.sh) pseq.assoc.Pvalue0.05"
fi


 #### 0       VAR     chr1:949654:rs8997
 #### 1       REF     A
 #### 2       ALT     G
 #### 3       MAF     0.914894
 #### 4       HWE     0.223615
 #### 5       MINA    15
 #### 6       MINU    25
 #### 7       OBSA    135
 #### 8       OBSU    100
 #### 9       REFA    0
 #### 10      HETA    15
 #### 11      HOMA    120
 #### 12      REFU    3
 #### 13      HETU    19
 #### 14      HOMU    78
 #### 15      P       0.0113523
 #### 16      OR      2.42857
 #### 17      PDOM    0.0757219
 #### 18      ORDOM   9.72821
 #### 19      PREC    0.0295128
 #### 20      ORREC   2.25641
 #### [2] : ################################################################################
 #### [2] : ################################################################################
 #### File : [CAD.FinalVCF.p100vs130.assoc.Pvalue0.05]
 #### 
 #### 
 #### 
 #### 0       CHROM   1
 #### 1       POS     100133227
 #### 2       ID      .
 #### 3       REF     A
 #### 4       ALT     G
 #### 5       QUAL    2119.96
 #### 6       FILTER  PASS
 #### 7       Impact  SYNONYMOUS_CODING
 #### 8       Effect_Impact   LOW
 #### 9       Functional_Class        SILENT
 #### 10      Codon_Change    ctA/ctG
 #### 11      Amino_Acid_change       L
 #### 12      Gene_Name       PALMD
 #### 13      Gene_BioTypeCoding      protein_coding
 #### 14      Coding  CODING
 #### 15      Transcript      ENST00000263174
 #### 16      Exon    exon_1_100133198_100133322
 #### [2] : ################################################################################
 #### [2] : ################################################################################
 #### File : [000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.SelectVariants.SNP.vcf.VariantFiltration.vcf.ApplyRecalibration.vcf.CombineVariants.vcf.GRCh37.63.vcf.SNPEFF.parsing.uniq]



