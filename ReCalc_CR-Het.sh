#!/bin/bash

. ~/.bash_function


# 1 : plink name
# 2 : output suffix name
# 3 : dirname

# Default setting
SUFFIX_default=BasicQC
DIR_default=BasicQC-ReCalculate_CR_HET.`date +%Y%m%d%H%M%S`


# ARGV setting

IN=$1
SUFFIX=${2:-$SUFFIX_default}
DIR=${3:-$DIR_default}


# DIR and Symbolic setting 

[ ! -d $DIR ] && mkdir $DIR
cp -as  $(readlink -f $IN).??? $DIR
cd $DIR

# script 

if [ -f "$IN.bed" ]; then

	## basic QC
	#plink2 --bfile $IN --geno 0.05 --hwe 0.000001 --make-bed --out $IN.$SUFFIX --allow-no-sex --threads 1 
	plink2 --bfile $IN --make-bed --out $IN.$SUFFIX --allow-no-sex --threads 1 


	# excute time : 2017-04-27 09:42:30 : step 2 : write variety output
	plink2 --bfile $IN.$SUFFIX --hardy --freq --missing --het --out $IN.$SUFFIX --allow-no-sex --threads 1


	# excute time : 2017-04-27 09:53:01 : step 3 : space to tab
	PlinkOut2Tab.sh $IN.$SUFFIX.het 


	# excute time : 2017-04-27 09:54:45 : step 4 : space to tab
	PlinkOut2Tab.sh $IN.$SUFFIX.imiss 


	# excute time : 2017-04-27 10:29:42 : step 5 : call rate
	perl -F'\t' -anle'if($. != 1){ print join "\t", $F[0], (1-$F[5])*100 }' $IN.$SUFFIX.imiss.tab > $IN.$SUFFIX.imiss.tab.call_rate


	# excute time : 2017-04-27 10:31:13 : step 6 : het rate
	 perl -F'\t' -anle'if($. != 1){ print join "\t", $F[0], (1-($F[2]/$F[4]))*100 }' $IN.$SUFFIX.het.tab > $IN.$SUFFIX.het.tab.het_rate


	# excute time : 2017-04-27 10:32:57 : step 7 : final
	join.NoHeader.sh $IN.$SUFFIX.imiss.tab.call_rate $IN.$SUFFIX.het.tab.het_rate  1 1 2  > $IN.$SUFFIX.CR_HET

	# excute time : 2017-11-16 15:37:05 : MAF
	PlinkOut2Tab.sh $IN.$SUFFIX.frq


	# excute time : 2017-11-16 15:37:20 : CR
	PlinkOut2Tab.sh $IN.$SUFFIX.lmiss


	# excute time : 2017-11-16 15:42:06 : step1
	join.h.sh $IN.$SUFFIX.frq.tab $IN.$SUFFIX.lmiss.tab "1,2" "1,2" 5  > $IN.$SUFFIX.Marker.step1


	# excute time : 2017-11-16 15:44:54 : step2
	tblmutate -e '$CR=sprintf "%.2f", (1-$F_MISS)*100; $CR' -l CR $IN.$SUFFIX.Marker.step1 > $IN.$SUFFIX.Marker


	\rm -rf $IN.$SUFFIX $IN.$SUFFIX.Marker.step1

else
	usage "PLink_Name [Suffix_Name:BasicQC] [DIR_Name:BasicQC-ReCalculate_CR_HET.today_now_time]" 

fi
 
 

