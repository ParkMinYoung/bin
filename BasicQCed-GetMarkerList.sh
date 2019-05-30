

#!/bin/bash

. ~/.bash_function


# 1 : plink name
# 2 : output suffix name
# 3 : dirname

# Default setting
SUFFIX_default=BasicQC
DIR_default=BasicQCed-MarkerList.`date +%Y%m%d%H%M%S`


# ARGV setting

IN=$1
SUFFIX=${2:-$SUFFIX_default}
DIR=${3:-$DIR_default}



# script 

if [ -f "$IN.bed" ];then
	
# DIR and Symbolic setting 

[ ! -d $DIR ] && mkdir $DIR
cp -as  $(readlink -f $IN).??? $DIR
cd $DIR


	plink2 --bfile $IN --geno 0.05 --write-snplist --out $IN.$SUFFIX.geno
	plink2 --bfile $IN --hwe 0.000001 --write-snplist --out $IN.$SUFFIX.hwe

	(cut -f1 $IN.$SUFFIX.geno.snplist; cut -f2 $IN.bim) | sort | uniq -u > $IN.$SUFFIX.geno.snplist.filterout
	(cut -f1 $IN.$SUFFIX.hwe.snplist; cut -f2 $IN.bim) | sort | uniq -u > $IN.$SUFFIX.hwe.snplist.filterout

	 
	(awk '{print $1"\tHWE"}' $IN.$SUFFIX.hwe.snplist.filterout; awk '{print $1"\tGENO"}' $IN.$SUFFIX.geno.snplist.filterout ) > FilterOutList


else
        usage "PLink_Name [Suffix_Name:BasicQC] [DIR_Name:BasicQCed-MarkerList.today_now_time]" 

fi


 
