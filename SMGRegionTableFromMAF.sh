#!/bin/sh


. ~/.bash_function

if [ $# -eq 2 ] && [ -f $1 ] && [ -f $2 ]; then

perl -F'\t' -MMin -ane'
if( @ARGV && $ARGV =~ /smg$/ ){
	
	# gene to LRT p-value
	$h{$F[0]} = $F[9];
	$m{$F[0]}{pvalue} = $F[9];
}elsif( $h{$F[0]} ){
	
	if( $F[8]=~/(De_novo_Start_InFrame|Frame_Shift_Del|Frame_Shift_Ins|In_Frame_Del|In_Frame_Ins|Missense_Mutation|Nonsense_Mutation|Nonstop_Mutation|Silent|Splice_Site|Intron)/ ){
		$m{$F[0]}{$F[8]}++
	}
}

}{
	mmfss("SMGRegionTable",%m)
' $1 $2
# smg S1234.maf

else
	usage "smg Merged.all.maf"
fi


## 5       De_novo_Start_InFrame   0
## 6       Frame_Shift_Del 0
## 7       Frame_Shift_Ins 0
## 8       In_Frame_Del    0
## 9       In_Frame_Ins    0
## 10      Intron  0
## 11      Missense_Mutation       7
## 12      Nonsense_Mutation       0
## 13      Nonstop_Mutation        0
## 14      Silent  2
## 15      Splice_Site     0



# # ==> smg <==
# # #Gene	AT_Transitions	AT_Transversions	CG_Transitions	CG_Transversions	CpG_Transitions	CpG_Transversions	Indels	P-value FCPT	P-value LRT	P-value CT	FDR FCPT	FDR LRT	FDR CT
# # AHNAK2	25	9	9	13	11	1	0	0	0	0	0	0	0
# # HRNR	10	0	6	6	19	2	0	0	0	0	0	0	0
# # MUC16	29	17	38	9	18	5	0	0	0	0	0	0	0
# # NBPF12	17	2	2	3	0	0	0	0	0	0	0	0	0
# # OR5H5P	10	6	2	0	1	0	2	0	0	0	0	0	0
# # RPL3P2	10	2	2	2	3	1	0	0	0	0	0	0	0
# # PRAMEF6	0	0	4	4	0	3	0	1.11022302462516e-16	0	1.01111147506021e-22	1.83186799063151e-13	0	1.66833393384935e-19
# # HLA-C	3	1	5	5	0	0	0	1.11022302462516e-15	0	3.42331179972369e-21	1.42478621493562e-12	0	4.94240641085108e-18
# # RBPJP2	2	0	0	4	0	0	0	6.66133814775094e-16	0	4.43177803451255e-21	9.61730695081542e-13	0	5.68744847762444e-18


# # 0       Hugo_Symbol     NOL9
# # 1       Entrez_Gene_Id  79707
# # 2       Center  sequencing.center
# # 3       NCBI_Build      37
# # 4       Chromosome      1
# # 5       Start_position  6609792
# # 6       End_position    6609792
# # 7       Strand  +
# # 8       Variant_Classification  5'Flank
# # 9       Variant_Type    INS
# # 10      Reference_Allele        G
# # 11      Tumor_Seq_Allele1       G
# # 12      Tumor_Seq_Allele2       GT
# # 13      dbSNP_RS        novel
# # 14      dbSNP_Val_Status
# # 15      Tumor_Sample_Barcode    S1
# # 16      Matched_Norm_Sample_Barcode     S1
# # 17      Match_Norm_Seq_Allele1  G
# # 18      Match_Norm_Seq_Allele2  G
# # 19      Tumor_Validation_Allele1
# # 20      Tumor_Validation_Allele2
# # 21      Match_Norm_Validation_Allele1   
# # 22      Match_Norm_Validation_Allele2   
# # 23      Verification_Status
# # 24      Validation_Status
# # 25      Mutation_Status Somatic
# # 26      Sequencing_Phase
# # 27      Sequence_Source WES
# # 28      Validation_Method
# # 29      Score   
# # 30      BAM_File
# # 31      Sequencer       Illumina HiSeq
# # 32      ENST00000464383 ENST00000464383
# # [2] : ################################################################################
# # [2] : ################################################################################
# # File : [S1234.maf]
# # 
