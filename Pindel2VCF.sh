##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">
##INFO=<ID=AC,Number=.,Type=Integer,Description="Alternate Allele Count">
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total Allele Count">
##ALT=<ID=DEL,Description="Deletion">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DS,Number=1,Type=Float,Description="Genotype dosage from MaCH/Thunder">
##FORMAT=<ID=GL,Number=.,Type=Float,Description="Genotype Likelihoods">
##INFO=<ID=AA,Number=1,Type=String,Description="Ancestral Allele, ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/pilot_data/technical/reference/ancestral_alignments/README">
##INFO=<ID=AF,Number=1,Type=Float,Description="Global Allele Frequency based on AC/AN">
##INFO=<ID=AMR_AF,Number=1,Type=Float,Description="Allele Frequency for samples from AMR based on AC/AN">
##INFO=<ID=ASN_AF,Number=1,Type=Float,Description="Allele Frequency for samples from ASN based on AC/AN">
##INFO=<ID=AFR_AF,Number=1,Type=Float,Description="Allele Frequency for samples from AFR based on AC/AN">
##INFO=<ID=EUR_AF,Number=1,Type=Float,Description="Allele Frequency for samples from EUR based on AC/AN">
##INFO=<ID=VT,Number=1,Type=String,Description="indicates what type of variant the line represents">
##INFO=<ID=SNPSOURCE,Number=.,Type=String,Description="indicates if a snp was called when analysing the low coverage or exome alignment data">
##reference=GRCh37
##SnpEffVersion="2.1a (build 2012-04-20), by Pablo Cingolani"
##SnpEffCmd="SnpEff eff -v -t GRCh37.66 1kg/ALL.wgs.phase1_release_v3.20101123.snps_indels_sv.sites.vcf "
##INFO=<ID=EFF,Number=.,Type=String,Description="Predicted effects for this variant.Format: 'Effect ( Effect_Impact | Functional_Class | Codon_Change | Amino_Acid_change | Gene_Name | Gene_BioType | Coding | Transcript | Exon [ | ERRORS | WARNINGS ] )' ">
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO
#1       10583   rs58108140      G       A       100.0   PASS    AVGPOST=0.


perl -F'\t' -anle'
if( $.==1 ){
	print "##INFO=<ID=TMP,Number=1,Type=String,Description=\"TMP pseudo INFO\">";
	print "#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO";
}

if( $ARGV =~ /pindel_SI.filtered/ ){

	if( $.%2==1 ){
		$F[3]=~/ChrID chr(\w+)/;
		$chr=$1;
		$F[2]=~/\"(\w+)\"/;
		$geno=$1;
		$bp=$F[5];
		$F[1]=~s/\s+/./;
		$id="$F[0].$F[1]";
	}else{
		/^\w+(\w)\s/;

		$ref="$1";
		$alt=$1.$geno;

		if($chr=~/_/){
			next;
		}
		print join "\t", $chr,$bp,"$id",$ref,$alt,50,"PASS","TMP=1.1";
	}
}elsif( $ARGV =~ /pindel_D.filtered/ ){
	if( ++$c%2==1 ){
		$F[3]=~/ChrID chr(\w+)/;
		$chr=$1;
		$bp=$F[5];
		$F[1]=~s/\s+/./;
		$id="$F[0].$F[1]";
	}else{
		/^[A-Z]+([A-Z])([a-z]+)[A-Z]+/;
		$ref = $1.$2;
		$alt = $1;
		$len = length $2;
		$bp -= $len;

		if($chr=~/_/){
			next;
		}
		print join "\t", $chr,$bp,"$id",$ref,$alt,50,"PASS","TMP=1.1";
	}
}

' $@ > Pindel.Uniq.vcf

#GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $1.vcf


#!# #!# 1  5
#!# #!# 2  D 1
#!# #!# 3  NT 0 ""
#!# #!# 4  ChrID chr1
#!# #!# 5  BP 1653332
#!# #!# 6  1653334
#!# #!# 7  BP_range 1653332
#!# #!# 8  1653335
#!# #!# 9  Supports 6
#!# #!# 10  5
#!# #!# 11  + 6
#!# #!# 12  5
#!# #!# 13  - 0
#!# #!# 14  0
#!# #!# 15  S1 7
#!# #!# 16  SUM_MS 360
#!# #!# 17  2
#!# #!# 18  NumSupSamples 2
#!# #!# 19  2
#!# #!# 20  H112971N_H-256N 2 2 0 0
#!# #!# 21  H112971T_H-256T 4 3 0 0
#!# #!# 





#!# #!# 0       5
#!# #!# 1       I 1
#!# #!# 2       NT 1 "C"
#!# #!# 3       ChrID chr1
#!# #!# 4       BP 2333944
#!# #!# 5       2333945
#!# #!# 6       BP_range 2333944
#!# #!# 7       2333948
#!# #!# 8       Supports 6
#!# #!# 9       6
#!# #!# 10      + 6
#!# #!# 11      6
#!# #!# 12      - 0
#!# #!# 13      0
#!# #!# 14      S1 7
#!# #!# 15      SUM_MS 360
#!# #!# 16      2
#!# #!# 17      NumSupSamples 2
#!# #!# 18      2
#!# #!# 19      H112971N_H-256N 2 2 0 0
#!# #!# 20      H112971T_H-256T 4 4 0 0
#!# #!# [3] : ################################################################################
#!# #!# [3] : ################################################################################
#!# #!# File : [pindel_SI.filtered]
#!# #!# 















##0       1       1
##1       112161462       112161463
##2
##3       A       A
##4       AAAATN  AAATAN

