perl -F'\t' -anle'
if(@ARGV){ 
	$h{ "$F[0]:$F[2]:$F[3]" } = join "\t", @F[5..8];
}elsif( /^Chr/ ){
	print "$_\t#Sample\tSampleList\tSampleGeneCount\tSampleGeno"
}elsif( $h{ "$F[0]:$F[1]:$F[3]/$F[4]" } ){
	print "$_\t",$h{"$F[0]:$F[1]:$F[3]/$F[4]"}

}else{
	print "$_\t.\t."
}
' $1 AnnoVarAnnotation.txt > AnnoVarAnnotation.Report
#' MergeVarScanForVEP.input AnnoVarAnnotation.txt > AnnoVarAnnotation.Report
perl -F'\t' -anle' map { $h{$_}++ } split ",", $F[26] }{ map { print "$_\t$h{$_}" } sort keys %h'  AnnoVarAnnotation.Report > AnnoVarAnnotation.Report.SamplesCount


perl -F'\t' -anle'$.>1 ? ($F[25] > 1 ? print : 0) : print' AnnoVarAnnotation.Report > AnnoVarAnnotation.Report.2samples
GetPossiblePair.sh  27 "," AnnoVarAnnotation.Report.2samples
#perl -F'\t' -anle'$.>1?($F[14] ne "." ? print : 0):print' AnnoVarAnnotation.Report.2samples  | cut -f1-5,9-10,12- >
perl -F'\t' -anle'$.>1?($F[14] ne "." ? print : 0):print' AnnoVarAnnotation.Report.2samples > AnnoVarAnnotation.Report.2samples.LJB_All



for i in `ls AnnoVarAnnotation.Report.2samples AnnoVarAnnotation.Report.2samples.LJB_All AnnoVarAnnotation.Report`

		do 
		sh AnnoVarAnnotation.Report2GeneSummary.sh $i
		perl  -nle'print if $.==1; print if /^(AF10|AMLCR2|ARHGEF12|ASXL1|CBFB|CEBPA|CHIC2|DNMT3A|ETV6|EZH2|FLT3|GATA2|GMPS|IDH1|IDH2|JAK2|KIT|KRAS|LPP|MLF1|MLL|NPM1|NRAS|NSD1|NUP214|PICALM|PTPN11|PU1|RARA|RUNX1|SH3GL1|TET2|TP53|WHSC1L1|WT1)/' $i.Geno2RegionSummary.txt > $i.Geno2RegionSummary.txt.AML
		perl -F'\t' -anle'print if $.==1; print if $F[12] =~ /^(AF10|AMLCR2|ARHGEF12|ASXL1|CBFB|CEBPA|CHIC2|DNMT3A|ETV6|EZH2|FLT3|GATA2|GMPS|IDH1|IDH2|JAK2|KIT|KRAS|LPP|MLF1|MLL|NPM1|NRAS|NSD1|NUP214|PICALM|PTPN11|PU1|RARA|RUNX1|SH3GL1|TET2|TP53|WHSC1L1|WT1)/' $i > $i.AML.candidates
		
		perl  -nle'print if $.==1; print if /^(CASP8|DLEC1|RASSF1|PIK3CA|IRF1|PRKN|EGFR|BRAF|MAP3K8|ERCC6|SLC22A1L|PPP2R1B|KRAS|ERBB2|CYP2A6|TP53|MET|STK11|PARK2|NKX2-1|DOK2|ALK|EML4|LNCR2|LNCR1|LNCR3|LNCR4|LNCR5|MPO)/' $i.Geno2RegionSummary.txt > $i.Geno2RegionSummary.txt.Lung
		perl -F'\t' -anle'print if $.==1; print if $F[12] =~ /^(CASP8|DLEC1|RASSF1|PIK3CA|IRF1|PRKN|EGFR|BRAF|MAP3K8|ERCC6|SLC22A1L|PPP2R1B|KRAS|ERBB2|CYP2A6|TP53|MET|STK11|PARK2|NKX2-1|DOK2|ALK|EML4|LNCR2|LNCR1|LNCR3|LNCR4|LNCR5|MPO)/' $i > $i.Lung.candidates

done


## 
## 0       Chr     1
## 1       Bp      100127855
## 2       Rs      .
## 3       Ref     C
## 4       Alt     A
## 5       Qual    50.0
## 6       Filter  PASS
## 7       Data    TMP=1.1;EFF=INTRON(MODIFIER||||PALMD|protein_coding|CODING|ENST00000263174|)
## 8       ANNOVAR_SIFT    .
## 9       AminoAcid_Change        .
## 10      DGV     Name=4237
## 11      ExonNumber      .
## 12      GENE    .
## 13      GeneSymbol      PALMD
## 14      LJB_All .
## 15      LJB_GERP++      .
## 16      LJB_LRT .
## 17      LJB_Polyphen2   .
## 18      LJB_SIFT        .
## 19      LJB_phylop      .
## 20      REF_ID  .
## 21      Region  intronic
## 22      TFBS_Name       .
## 23      TFBS_Score      .
## 24      cds_Number      .
## [2] : ################################################################################
## [2] : ################################################################################
## File : [AnnoVarAnnotation.txt]
## 
## 
## 0       1       1
## 1       100127855       100127913
## 2       100127855       100127913
## 3       C/A     T/C
## 4       +       +
## 5       1       1
## 6       32403389        42210306
## [2] : ################################################################################
## [2] : ################################################################################
## File : [MergeVarScanForVEP.input]
## 
