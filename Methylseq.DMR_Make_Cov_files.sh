#!/bin/bash

. ~/.bash_function


# execute time : 2018-12-24 21:58:41 : get list
# find /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m* | grep cov.gz$ > list


if [ -f "$1" ] ;then


COV_FILE_LIST=${2:-list}

if [ ! -f "$COV_FILE_LIST" ];then

	find $PWD/../../ | grep cov.gz$ > $COV_FILE_LIST	
fi 


# execute time : 2018-12-24 22:44:37 : make cov files
perl -F'\t' -MMin -anle'
if(@ARGV){
		/\/.+\/(.+?)_\w{6,8}_L/; 
		$h{$1}=$_
}elsif($h{$F[0]} && $h{$F[1]}){ 
		@Ctrl = split ",", $F[0]; 
		@Case = split ",", $F[1]; 
		$group = $Ctrl[0]."-".$Case[0]; 
		
		DMR_make_cov_file($group, 0, \@Ctrl, \%h); 
		DMR_make_cov_file($group, 1, \@Case, \%h);   

}' $COV_FILE_LIST $1 | awk '{ print $2"\t"$3"\t"$4 >$1".cov"}'


else

cat <<EOF

# ARGV  

============================================================

$(_red "1. bismark.cov.gz file list ${NORM}") : list
$(_blue "1. Control IDs${NORM}") : Pairs
$(_blue "2. Case IDs${NORM}") : Pairs

============================================================

## list

# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m1/2018_m1_AGCAGGAA_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m2/2018_m2_GAGCTGAA_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m3/2018_m3_AAACATCG_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m4/2018_m4_GAGTTAGC_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m5/2018_m5_CGAACTTA_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m6/2018_m6_GATAGACA_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m7/2018_m7_AAGGACAC_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz
# /home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1/2018_m8/2018_m8_GACAGTGC_L001_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz


## Pairs

# 2018_m1	2018_m3
# 2018_m2	2018_m4
# 2018_m1	2018_m5
# 2018_m2	2018_m6
# 2018_m1	2018_m7
# 2018_m2	2018_m8
# 2018_m3	2018_m7
# 2018_m4	2018_m7

# or comman separation group

# A,B,C	D,E,F
# B,E	C,F
# 1,2,3	5,6,7


EOF

	usage "list Pairs"

fi

