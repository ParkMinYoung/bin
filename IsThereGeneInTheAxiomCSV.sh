#!/bin/bash

. ~/.bash_function

if [ $# -ge 2 ];then

perl -F'\t' -anle'
if(@ARGV){
	$h{$F[0]}=$F[1]
}else{ 
	if(/^Probe/){
		print join "\t", "Gene","Group", "Region", @F
	}else{ 
		
		$gene=""; 
		$region=""; 
		$group="";

		@genes = split / \/\/\/ /, $F[15]; 
		
		map {  
			@gene = split / \/\/ /, $_; 
			
 			if( $h{ $gene[4] } ){
 				
 				$gene   = $gene[4]; 
 				$region = $gene[1]; 
 				$group  = $h{ $gene[4] };
 			}  
		} @genes; 

		print join "\t", $gene, $region, $group, @F if $gene;
	} 
}
' $1 $2 


else


cat << EOF

============================================================

${BLUE}Group file format : more than two${NORM}

${RED}1. Gene${NORM}
${RED}2. Group${NORM}

Gene	Group
APC		group1
BMPR1A	group1
BRCA1	group1
BRCA2	group1
MEN1	group1
MLH1	group1
MSH2	group1
MSH6	group1
MUTYH	group1


============================================================
EOF


	usage "Group Axiom_KORV1_1.na35.annot.csv.tab"
fi


# Group Axiom_KORV1_1.na35.annot.csv.tab


## Group file format

