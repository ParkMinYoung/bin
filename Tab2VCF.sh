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




Tab2VCFformat.sh $1

perl -F'\t' -anle'
if( $.==1 ){
	print "##INFO=<ID=TMP,Number=1,Type=String,Description=\"TMP pseudo INFO\">";
	print "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO";
}
	next if $F[0]=~/_/;		
	$F[0]=~s/chr//;
	#$F[9]=~tr/ACGTacgt/TGCAtgca/ if $F[6] eq "-";
	print join "\t", @F[0..4],"50","PASS","TMP=1.1";
' $1 > $1.vcf

#GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $1.vcf

##0       1       1
##1       112161462       112161463
##2
##3       A       A
##4       AAAATN  AAATAN

