

perl -F'\t' -MMin -ane'
chomp@F;
if($ARGV=~/dbsnp135.vcf.annovar.exonic_variant_function$/){
	$key=join "\t",@F[8..$#F];
	$exon_type=$F[1];
	($data)=split ",",$F[2];
	($gene,$ref,$exonN,$cds,$aa)=split ":",$data;
#print "($gene,$ref,$exonN,$cds,$aa)\n";
	$h{$key}{GENE}=$gene;
	$h{$key}{REF_ID}=$ref;
	$h{$key}{ExonNumber}=$exonN;
	$h{$key}{cds_Number}=$cds;
	$h{$key}{AminoAcid_Change}=$aa;
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_avsift_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{ANNOVAR_SIFT}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_dgv$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{DGV}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_all_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{LJB_All}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_gerp\+\+_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{"LJB_GERP++"}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_lrt_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{LJB_LRT}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_phylop_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{LJB_phylop}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_pp2_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{LJB_Polyphen2}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_ljb_sift_dropped$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{LJB_SIFT}=$F[1];
}
elsif($ARGV=~/dbsnp135.vcf.annovar.hg19_tfbsConsSites$/){
	$key=join "\t",@F[7..$#F];
	($score,$name)= split ";", $F[1];
	$h{$key}{TFBS_Score}=$score;
	$h{$key}{TFBS_Name}=$name;
}
elsif($ARGV=~/dbsnp135.vcf.annovar.variant_function$/){
	$key=join "\t",@F[7..$#F];
	$h{$key}{Region}=$F[0];
	$h{$key}{GeneSymbol}=$F[1];
}
}{
	mmfss_dot("AnnoVarAnnotation",%h);
' `ls *dbsnp135.vcf.annovar.* | grep -v log$ `

mv AnnoVarAnnotation.txt AnnoVarAnnotation.txt.tmp

head -1 AnnoVarAnnotation.txt.tmp | perl -nle'$sub=join "\t", qw/Chr Bp Rs Ref Alt Qual Filter Data Format Normal Tumor/;s/probeset_id/$sub/; print' > AnnoVarAnnotation.txt
sed -n '2,$p' AnnoVarAnnotation.txt.tmp >> AnnoVarAnnotation.txt
rm -rf AnnoVarAnnotation.txt.tmp


## A1.A2.varscan.snp.Somatic.VEP.input.vcf.GRCh37.66.vcf.header.dbsnp135.vcf.annovar.variant_function
## ncRNA_intronic	WASH7P	1	15190	15190	G	A	1	15190	rs71230572	G	A	50.0	PASS	TMP=1.1;EFF=DOWNSTREAM(MODIFIER||||DDX11L1|processed_transcript|NON_CODING|ENST00000450305|),DOWNSTREAM(MODIFIER||||DDX11L1|processed_transcript|NON_CODING|ENST00000456328|),DOWNSTREAM(MODIFIER||||DDX11L1|processed_transcript|NON_CODING|ENST00000515242|),DOWNSTREAM(MODIFIER||||DDX11L1|processed_transcript|NON_CODING|ENST00000518655|),DOWNSTREAM(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000430492|),DOWNSTREAM(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000537342|),INTRON(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000423562|),INTRON(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000438504|),INTRON(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000488147|),INTRON(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000538476|),INTRON(MODIFIER||||WASH7P|unprocessed_pseudogene|NON_CODING|ENST00000541675|)
## 



## A1.A2.varscan.snp.Somatic.VEP.input.vcf.GRCh37.66.vcf.header.dbsnp135.vcf.annovar.exonic_variant_function
## line9	nonsynonymous SNV	PRAMEF11:NM_001146344:exon2:c.G109A:p.A37T,	1	12888415	12888415	C	T	1	12888415	rs75875937	C	T	50.0	PASS	TMP=1.1;EFF=NON_SYNONYMOUS_CODING(MODERATE|MISSENSE|Gcc/Acc|A37T|PRAMEF11|protein_coding|CODING|ENST00000437584|exon_1_12888357_12888664),NON_SYNONYMOUS_CODING(MODERATE|MISSENSE|Gcc/Acc|A37T|PRAMEF11|protein_coding|CODING|ENST00000535591|exon_1_12888357_12888664),NON_SYNONYMOUS_CODING(MODERATE|MISSENSE|Gcc/Acc|A78T|PRAMEF11|protein_coding|CODING|ENST00000331684|exon_1_12888357_12888604)
## 
