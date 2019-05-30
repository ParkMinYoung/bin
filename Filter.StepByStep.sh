
perl -F'\t' -MMin -ane'
chomp;
$k = join "\t", @F[0,1,3,4];

if(@ARGV){
	next if $.==1;

	$k2anno{$k} = $F[9] || $F[7];
	if($F[9] eq "SILENT"){
			next
	}elsif($F[11]){
		@a = split /\d+/, $F[11];
		if(@a==2 && $a[0] ne $a[1]){
			$nonsyn{$k}++ 
		}else{
				print "@a $a[0] $a[1]\n";print ;exit;
		}

	}elsif($F[7] =~ /^(SPLICE|START|STOP)/){
		$nonsyn{$k}++;
	}

}else{
	next if /^Chr/;
	$anno = $k2anno{$k};	
	if(!$anno){print;exit;}


	$h{$anno}{"01.Total"}++;
	$h{total}{"01.Total"}++;

	if($nonsyn{$k}){
		$h{$anno}{"02.ChangingProtein"}++;
		$h{total}{"02.ChangingProtein"}++;
			
		if($F[2] eq "." ){
			$h{$anno}{"03.dbSNP.Filtering"}++;
			$h{total}{"03.dbSNP.Filtering"}++;

			$geno = split ",", $F[28];
			
			$cnt= $geno =~ tr/ACGT/ACGT/;
			
			if( $cnt == 2 ){
				$h{$anno}{"04.Homozygous"}++;
				$h{total}{"04.Homozygous"}++;
			}else{
				$h{$anno}{"04.Heterozygous"}++;
				$h{total}{"04.Heterozygous"}++;
			}
		}
	}
}
}{ mmfss("FilteringStepByStep",%h)

' MergeVarScanForVEP.input.vcf.GRCh37.66.vcf.header.dbsnp135.vcf.GRCh37.66.vcf.SNPEFF.parsing.uniq AnnoVarAnnotation.Report 


# # 0       CHROM   1
# # 1       POS     100152277
# # 1       ID      .
# # 3       REF     C
# # 3       ALT     T
# # 5       QUAL    50.0
# # 6       FILTER  PASS
# # 7       Impact  EXON
# # 8       Effect_Impact   MODIFIER
# # 9       Functional_Class
# # 10      Codon_Change
# # 11      Amino_Acid_change
# # 12      Gene_Name       PALMD
# # 13      Gene_BioTypeCoding      protein_coding
# # 14      Coding  CODING
# # 15      Transcript      ENST00000496843
# # 16      Exon
# # 17      ./.     0
# # 18      0/0     0
# # 19      0/1     0
# # 20      1/1     0
# # [2] : ################################################################################
# # [2] : ################################################################################
# # File : [MergeVarScanForVEP.input.vcf.GRCh37.66.vcf.header.dbsnp135.vcf.GRCh37.66.vcf.SNPEFF.parsing.uniq]
# # 
# # 
# # 0       Chr     1
# # 1       Bp      100111957
# # 2       Rs      .
# # 3       Ref     C
# # 4       Alt     A
# # 5       Qual    50.0
# # 6       Filter  PASS
# # 7       Data    TMP=1.1;EFF=INTRON(MODIFIER||||PALMD|protein_coding|CODING|ENST00000263174|)
# # 8       ANNOVAR_SIFT    .
# # 9       AminoAcid_Change        .
# # 10      DGV     Name=4237
# # 11      ExonNumber      .
# # 12      GENE    .
# # 13      GeneSymbol      PALMD
# # 14      LJB_All .
# # 15      LJB_GERP++      .
# # 16      LJB_LRT .
# # 17      LJB_Polyphen2   .
# # 18      LJB_SIFT        .
# # 19      LJB_phylop      .
# # 20      REF_ID  .
# # 21      Region  intronic
# # 22      TFBS_Name       .
# # 23      TFBS_Score      .
# # 24      cds_Number      .
# # 25      #Sample 1
# # 26      SampleList      42727323
# # 27      SampleGeneCount 26|0|47|2
# # 28      SampleGeno      C|M
# # [2] : ################################################################################
# # [2] : ################################################################################
# # File : [AnnoVarAnnotation.Report]


