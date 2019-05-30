#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc


#/home/adminrig/src/10X/longranger/latest/longranger mkfastq --id=DL_CPS_NA12878 --run=/hiseq_ds2/novaseq/190327_A00547_0040_BH7HKJDRXX --csv=/hiseq_ds2/novaseq/190327_A00547_0040_BH7HKJDRXX/X10.csv --ignore-dual-index --localcores=16 --localmem=192 



RUN_DIR=$1
CSV=$2

OPTIONS="$3"


if [ $# -ge 2 ];then


        $LR mkfastq														   	\
           --run=$RUN_DIR 			                                       	\
		   --csv=$CSV														\
		   --ignore-dual-index												\
           $OPTIONS 


else
        
        usage "run_dir 10x.csv Options[\"--localcores=16 --localmem=192 --indices=SI-GA-A1 --uiport=3600 --id=sample\"]"
        
fi


