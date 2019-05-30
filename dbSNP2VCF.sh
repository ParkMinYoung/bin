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
	next if $F[1]=~/_/;		
	$F[1]=~s/chr//;
	$F[9]=~tr/ACGTacgt/TGCAtgca/ if $F[6] eq "-";
	($A,$B) = split "\/", $F[9];
	print join "\t", $F[1],$F[3],$F[4],$A,$B,"100.0","PASS","TMP=1.1";
' $1 > $1.vcf

GenomeAnalysisTK.EFFSNP GRCh37.63 $1.vcf

## 0       678     678
## 1       chr1    chr1
## 2       12252954        12253061
## 3       12252955        12253062
## 4       rs1061622       rs5746026
## 5       0       0
## 6       +       +
## 7       T       G
## 8       T       G
## 9       G/T     A/G
## 10      genomic genomic
## 11      single  single
## 12      by-cluster,by-frequency,by-submitter,by-1000genomes     by-cluster,by-frequency,by-1000genomes
## 13      0.33307 0.042301
## 14      0.235795        0.139144
## 15      missense        missense
## 16      exact   exact
## 17      1       1
## 18
## 19      23      15
## 20      1000GENOMES,AFFY,APPLERA_GI,BL,BUSHMAN,CANCER-GENOME,CGM_KYOTO,COMPLETE_GENOMICS,CUORCGL,EGP_SNPS,HGBASE,HGSV,ILLUMINA,ILLUMINA-UK,IMCJ-GDT,KRIBB_YJKIM,LEE,NHLBI-ESP,PERLEGEN,PGA-UW-FHCRC,SC_JCM,SEATTLESEQ,WIAF-CSNP,        1000GENOMES,AFFY,APPLERA_GI,CANCER-GENOME,CGM_KYOTO,EGP_SNPS,GMI,HGSV,ILLUMINA,ILLUMINA-UK,IMCJ-GDT,NHLBI-ESP,PERLEGEN,PGA-UW-FHCRC,SEATTLESEQ,
## 21      2       2
## 22      G,T,    A,G,
## 23      2279.000000,8668.000000,        191.000000,8797.000000,
## 24      0.208185,0.791815,      0.021251,0.978749,
## 25      maf-5-some-pop,maf-5-all-pops,genotype-conflict maf-5-some-pop,genotype-conflict
## 
