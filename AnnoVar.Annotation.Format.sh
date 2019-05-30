perl -F'\t' -anle'
$k=join "\t",@F[0,1];
if(@ARGV){
	$k=join "\t",@F[0,1];
	$v=join "\t",@F[2,8..$#F];
	$h{$k}=$v;
}elsif($h{$k}){
	print "$_\t$h{$k}";
}elsif(/^chrom/){
	print join "\t", $_,
		qw/Rs_Number
		  ANNOVAR_SIFT
		  AminoAcid_Change
		  DGV
		  ExonNumber
		  GENE
		  GeneSymbol
		  LJB_All
		  LJB_GERP++
		  LJB_LRT
		  LJB_Polyphen2
		  LJB_SIFT
		  LJB_phylop
		  REF_ID
		  Region
		  TFBS_Name
		  TFBS_Score
		  cds_Number/;
}

' $1 $2 > $2.Report
#AnnoVarAnnotation.txt A1.A2.varscan.snp > 

##0       probeset_id     1
##1       ANNOVAR_SIFT    100735903
##2       AminoAcid_Change        rs4579779
##3       DGV     A
##4       ExonNumber      G
##5       GENE    50.0
##6       GeneSymbol      PASS
##7       LJB_All TMP=1.1;EFF=DOWNSTREAM(MODIFIER||||RTCD1|protein_coding|CODING|ENST00000370126|),INTRON(MODIFIER||||RTCD1|protein_coding|CODING|ENST00000260563|),INTRON(MODIFIER||||RTCD1|protein_coding|CODING|ENST00000370128|),INTRON(MODIFIER||||RTCD1|protein_coding|CODING|ENST00000483474|),INTRON(MODIFIER||||RTCD1|protein_coding|CODING|ENST00000498617|),UPSTREAM(MODIFIER||||RP11-305E17.6.1|antisense|NON_CODING|ENST00000421185|)
##8       LJB_GERP++      0
##9       LJB_LRT 0
##10      LJB_Polyphen2   0
##11      LJB_SIFT        0
##12      LJB_phylop      0
##13      REF_ID  RTCA
##14      Region  0
##15      TFBS_Name       0
##16      TFBS_Score      0
##17      cds_Number      0
##18      0       0
##19      0       0
##20      0       0
##21      intronic        intronic
##22      0       0
##23      0       0
##24      0       0
##
