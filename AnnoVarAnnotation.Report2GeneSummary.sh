

FILE=$1

perl -F'\t' -MMin -MList::MoreUtils=uniq -asne'
chomp@F;
($region) = split ";", $F[21];


if( $F[9] =~ /p\.(\w)\d+(\w)/ ){
	$region = $1 eq $2 ? "syn" : "non-syn";
}

@samples = split ",", $F[26];

if( $region eq "non-syn" ){
	push @{$g{$F[12]}{$region}}, @samples+0;
	map { $s{$F[12]}{$_}++ } @samples;

}


$h{$F[12]}{$region}++;

}{

for $gene ( sort keys %g ){
	for $region ( sort keys %{$g{$gene}} ){
		@num = sort {$b <=> $a } @{ $g{$gene}{$region} };
		
		if ( $region eq "non-syn" ){
			$h{$gene}{$region."_Max1"} = $num[0];
			$h{$gene}{$region."_Max2"} = $num[1];
			
			@uniq_sam = uniq ( keys %{$s{$gene}} );
			$h{$gene}{$region."_UniqSamplesCount"} = @uniq_sam+0; 
			$h{$gene}{$region."_UniqSamples"} = join ",", @uniq_sam; 
			
			@uniq_sam_freq = sort { $s{$gene}{$b} <=> $s{$gene}{$a} } @uniq_sam;
			$h{$gene}{$region."_FrequentList"} = join ",", @uniq_sam_freq; 
			$h{$gene}{$region."_FrequentListCount"} = join ",", (map { $s{$gene}{$_} } @uniq_sam_freq); 

		}
	}
}


mmfss("$f.Geno2RegionSummary",%h)
' -- -f=$FILE $FILE

## exonic
## splicing
## intronic
## UTR3
## UTR5
## ncRNA_exonic
## ncRNA_intronic
## ncRNA_splicing
## ncRNA_UTR3
## ncRNA_UTR5
## upstream
## downstream
## intergenic

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
## 25      #Sample 1
## 26      SampleList      32403389
## 27      SampleGeneCount 14|0|6|2
## 28      SampleGeno      C|M
## [2] : ################################################################################
## [2] : ################################################################################
## File : [AnnoVarAnnotation.Report]


