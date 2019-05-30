#!/bin/bash

. ~/.bash_function

#$1 # plink
#$2 # Target Bed
#$3 # output

default_DIR=LD_Plink

if [ -f "$1.bed" ] & [ -f "$2" ];then

		PLINK=$1
		BED=$2
		OUT_DIR=${3:-$default_DIR}

		[ ! -d $OUT_DIR ] && mkdir $OUT_DIR



		 tail -n +2 $BED | \
		 while read chr start end etc; 
			do 
			output=$OUT_DIR/$chr.$start.$end
			
			/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $PLINK --chr $chr --from-bp $start --to-bp $end --make-bed --out $output --allow-no-sex --threads 10 >& /dev/null
			
		 done

else
	usage "PLINK TargetBed [OUT_DIR]"
fi


