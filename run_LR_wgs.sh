#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc


ID=$1
SAMPLES=$2
FASTQ_DIRS=$3
OPTIONS="$4"
REF=${5:-$LR_b37_ref}

GATK=$GATK4_0_3

if [ $# -ge 3 ];then



        $LR wgs 														   \
           --id=$ID                                                        \
           --sample=$SAMPLES                                               \
           --reference=$REF		                                           \
           --fastqs=$FASTQ_DIRS                                            \
           --vcmode=gatk:$GATK                                             \
           $OPTIONS 
#          --uiport=3600                                                   \
#          --localcores=16 --localmem=192


else
        
        usage "Output_dir Sample_IDs[\"A,B,C\" or \"A\"] fastq_dirs[\"A/outs/fastq_path,B/outs/fastq_path\" or \"A/outs/fastq_path\"] Options[\"--localcores=16 --localmem=192 --sex=female --targets=SSV3.bed --indices=SI-GA-A1 --uiport=3600\"] [REF_DIR:$LR_b37_ref]"
        
# CSP_NA12878_2_3_4 "NA12878-2,NA12878-3,NA12878-4" "/data/10xGenomics/Data/BH7HKJDRXX/outs/fastq_path,/data/10xGenomics/Data/BH5WJNDRXX/outs/fastq_path" "--sex=female"


fi


