#!/bin/sh

. ~/.bash_function

## 0       Chr     1
## 1       Bp      100152443
## 2       Rs      rs1338576
## 3       Ref     T
## 4       Alt     C
## 5       Qual    50.0
## 6       Filter  PASS
## 7       Data    TMP=1.1;EFF=INTRON(MODIFIER||||PALMD|protein_coding|CODING|ENST00000263174|),INTRON(MODIFIER||||PALMD|protein_coding|CODING|ENST00000496843|)
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
## 25      #Sample 2
## 26      SampleList      34981900,42102777
## [2] : ################################################################################
## [2] : ################################################################################
## File : [AnnoVarAnnotation.Report.2samples]



if [ $# -ge 2 ] ; then
	COL=$1
	DEL=$2
	F=$3

	echo "$COL $DEL $F"


perl -F'\t' -MMin -asne' 
next if $.==1;
chomp@F;
@list = split $delimit, $F[$col-1];
$final_idx = $#list;

for $i ( 0 .. $final_idx ){ 
	next if $i == $final_idx;
	for $j ( $i+1 .. $final_idx ){	
			if ( defined $list[$i] && defined $list[$_]){
				
				$h{ $list[$i] }{ $list[$j] }++; 
				$h{ $list[$j] }{ $list[$i] }++;
				
				$h{ Total }{ $list[$i] }++;
				$h{ $list[$i] }{ Total }++; 
				
				$h{ Total }{ $list[$j] }++;
				$h{ $list[$j] }{ Total }++; 
				
				$uniq{ $list[$i] }++;
				$uniq{ $list[$j] }++;
			}
		}
}

}{ 
	@samples = sort keys %uniq;

	for $i ( @samples ){
		@row_list = reverse sort { $h{$i}{$a} <=> $h{$i}{$b} } @samples;

		$h{$i}{max1}= $row_list[0];
		$h{$i}{max2}= $row_list[1];
		$h{$i}{max3}= $row_list[2];

		@col_list = reverse sort { $h{$a}{$i} <=> $h{$b}{$i} } @samples;

		$h{max1}{$i}= $col_list[0];
		$h{max2}{$i}= $col_list[1];
		$h{max3}{$i}= $col_list[2];
	}

	mmfss("pair.matrix",%h)

' -- -col=$COL -delimit=$DEL $F
#' -- -col=27 -delimit="," AnnoVarAnnotation.Report.2samples

else
	usage "column_num delimit_string(\",\",\"|\",\"xxx\") filename"
fi


