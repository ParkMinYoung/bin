#!/bin/sh


source ~/.bash_function
source ~/.GATKrc
GATK_param


if [ -f "$1" ];then

refflat=$2
R=${REF_FLAT:=$refflat}

perl -F'\t' -MList::MoreUtils=uniq -anle'
if(@ARGV){
	$h{$F[1]}=$F[0]
}else{
	@ref=$F[3]=~/(N\w_\d+)_/g;
	$F[3]=join ";", uniq @h{@ref};
	print join "\t",@F
}' $R $1 > $1.GeneSymbol.bed

else
	usage "XXX.bed.merge.bed [refflat.txt]"
fi





## merged.bed

# chr1    12049225        12049400        NM_014874_cds_2_0_chr1_12049226_f;NM_001127660_cds_1_0_chr1_12049226_f
# chr1    12052611        12052747        NM_014874_cds_3_0_chr1_12052612_f;NM_001127660_cds_2_0_chr1_12052612_f
# chr1    12056212        12056375        NM_014874_cds_4_0_chr1_12056213_f;NM_001127660_cds_3_0_chr1_12056213_f
# chr1    12057353        12057478        NM_014874_cds_5_0_chr1_12057354_f;NM_001127660_cds_4_0_chr1_12057354_f
# chr1    12058826        12058935        NM_014874_cds_6_0_chr1_12058827_f;NM_001127660_cds_5_0_chr1_12058827_f
# chr1    12059044        12059152        NM_014874_cds_7_0_chr1_12059045_f;NM_001127660_cds_6_0_chr1_12059045_f
# chr1    12061457        12061611        NM_001127660_cds_7_0_chr1_12061458_f;NM_014874_cds_8_0_chr1_12061458_f
# chr1    12061825        12061893        NM_001127660_cds_8_0_chr1_12061826_f;NM_014874_cds_9_0_chr1_12061826_f
# chr1    12062038        12062160        NM_001127660_cds_9_0_chr1_12062039_f;NM_014874_cds_10_0_chr1_12062039_f
# chr1    12064048        12064175        NM_001127660_cds_10_0_chr1_12064049_f;NM_014874_cds_11_0_chr1_12064049_f
# 



## refFlat

# C17orf76-AS1    NR_027161       chr17   +   
# C17orf76-AS1    NR_027160       chr1
# FAM138A NR_026818       chr1    -   
# LOC100132287    NR_028322       chr1
# KANK4   NM_181712       chr1    -   
# FAM101A NM_181709       chr12   +   
# PPP2R1B NM_181699       chr11   -   
# LOC100288069    NR_033908       chr1
# LINC00085       NR_024330       chr1
# FAM41C  NR_027055       chr1    -   

