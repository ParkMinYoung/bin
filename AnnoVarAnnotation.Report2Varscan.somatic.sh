 
perl -F'\t' -anle'
$k = join "\t", @F[0..3];
if($ARGV=~/AnnoVarAnnotation.Report$/){
	if(/^Chr/){
		$h{title} = join "\t", @F[7..$#F];
	}
	
	$k = join "\t", @F[0,1,3,4];
	$h{$k} = join "\t", @F[7..$#F];

}elsif(/^chrom/ && !$flag){
	print join "\t", "Name", $_, $h{title};
}elsif(/Somatic/ && $h{$k}){
	$ARGV =~ /^(.+)?\//;
	$sample=$1;
	$sample =~ s/\.\///;
	print join "\t", $sample, @F, $h{$k};
	
	if($h{$k} =~ /p\.(\w)\d+(\w)/ && $1 ne $2){
		print STDERR join "\t", $sample, @F, $h{$k};
	}
}

' Annotation/MergeVarScanForVEP.input/AnnoVarAnnotation.Report  `find  | grep snp$ | sort` 1> AnnoVarAnnotation.Report.Varscan.all  2> AnnoVarAnnotation.Report.Varscan.NonSyn



#0       Chr     1
#1       Bp      100181380
#2       Rs      .
#3       Ref     G
#4       Alt     A
#5       Qual    50.0
#6       Filter  PASS
#7       Data    TMP=1.1;EFF=INTRON(MODIFIER||||FRRS1|protein_coding|CODING|ENST00000287474|),INTRON(MODIFIER||||FRRS1|protein_coding|CODING|ENST00000414213|),INTRON(MODIFIER||||FRRS1|protein_coding|CODING|ENST00000489209|),UPSTREAM(MODIFIER||||FRRS1|protein_coding|CODING|ENST00000492943|)
#8       ANNOVAR_SIFT    .
#9       AminoAcid_Change        .
#10      DGV     .
#11      ExonNumber      .
#12      GENE    .
#13      GeneSymbol      FRRS1
#14      LJB_All .
#15      LJB_GERP++      .
#16      LJB_LRT .
#17      LJB_Polyphen2   .
#18      LJB_SIFT        .
#19      LJB_phylop      .
#20      REF_ID  .
#21      Region  intronic
#22      TFBS_Name       .
#23      TFBS_Score      .
#24      cds_Number      .
#25      #Sample 1
#26      SampleList      A3vs4
#27      SampleGeneCount 23|0|5|2
#28      SampleGeno      G|R
#[2] : ################################################################################
#[2] : ################################################################################
#File : [Annotation/MergeVarScanForVEP.input/AnnoVarAnnotation.Report]
#

#0       chrom   1
#1       position        12198
#2       ref     G
#3       var     C
#4       normal_reads1   11
#5       normal_reads2   5
#6       normal_var_freq 31.25%
#7       normal_gt       S
#8       tumor_reads1    12
#9       tumor_reads2    13
#10      tumor_var_freq  52%
#11      tumor_gt        S
#12      somatic_status  Germline
#13      variant_p_value 3.454019618575049E-7
#14      somatic_p_value 0.16288356236536836
#15      tumor_reads1_plus       6
#16      tumor_reads1_minus      6
#17      tumor_reads2_plus       7
#18      tumor_reads2_minus      6
#[2] : ################################################################################
#[2] : ################################################################################
#File : [A1vs2/A1vs2.varscan.snp]
#

