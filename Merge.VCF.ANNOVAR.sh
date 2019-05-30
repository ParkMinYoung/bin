
VCF=$1
ANNOVAR=$2

sift=/home/adminrig/src/SNPEFF/tmp/snpEff.20130404/SnpSift.jar
java -jar $sift extractFileds $VCF CHROM POS ID REF ALT MM GTCNT GTPATTERN > $VCF.tab

###CHROM  POS     ID      MM      GTPATTERN       GTCNT
##1       889238  rs3828049       1       0/0|0/1 1
##1       898542  rs186429850     1       0/0|0/1 1
##1       909238  rs3829740       1       1/1|0/1 1
##1       909309  rs3829738       1       0/0|0/1 1
##1       916549  rs6660139       1       1/1|0/0 1
##1       935222  rs2298214       1       1/1|0/1 1
##1       949608  rs1921  1       0/1|1/1 1
##1       1178482 rs78555129      1       0/0|0/1 1
##1       1178925 rs12093154      1       0/0|0/1 1


perl -F'\t' -anle'
if(@ARGV){

	if(/^#CHROM/){
		@head = @F[5..7];
	}else{

		($r,$a) = ($F[3], $F[4]);
		$rl= length($r);
		$al= length($a);
		if($rl > 1){
			$s=$F[1]+1;
			$h{"$F[0]:$s"}=join "\t", @F[5..7];
		}else{
			$h{"$F[0]:$F[1]"}=join "\t", @F[5..7];
		}
	}
}else{
	if(/^Gene/){
		print join "\t",@F,@head;
	}else{
		print join "\t", @F, $h{"$F[10]:$F[11]"};
	}
}
' $VCF.tab $ANNOVAR > $ANNOVAR.VCFAnno

# VCF 9Samples.vcf.PASS.vcf.GRCh37.68.Exonic.vcf.x0.vcf.PASS.vcf
# ANNOVAR 9Samples.vcf.PASS.vcf.GRCh37.68.Exonic.vcf.x0.vcf.PASS.vcf.annovar.annotate.exome_summary.csv.tab.table



##ISG15	nonsynonymous SNV	NM_005101:c.G248A:p.S83N	0.402	0.340	rs1921	T (0.620)	B (0.008)	P (0.002)	N (0.055)	1	949608	949608	G	A
##FAM132A	nonsynonymous SNV	NM_001014980:c.T691C:p.C231R	0.153	0.180	rs78555129	T (0.400)	B (0.000)	N (0.000)	C (0.975)	1	1178482	1178482	A	G
##FAM132A	nonsynonymous SNV	NM_001014980:c.C539T:p.A180V	0.096	0.140	rs12093154	T (0.700)	B (0.046)	P (0.729)	C (0.999)	1	1178925	1178925	G	A
##ACAP3	nonsynonymous SNV	NM_030649:c.C184T:p.R62C	0.006	0.010	rs145087137	D (1.000)	D (0.996)	NA (0.791)	C (0.999)	1	1238583	1238583	G	A

