#!/bin/bash

. ~/.bash_function

. ~/.minyoungrc


if [ -f "$1" ] && [ -f "$2" ] && [ $# -ge 3 ];then


		T_BAM=$(readlink -f $1)
		N_BAM=$(readlink -f $2)
		OUTPUT_prefix=$3
		
		ACTION=${4:-$ACTION}
		Nthreads=${5:-$Nthreads}
		BED=${6:-$BED}


		# execute time : 2019-04-08 15:52:48 :  call
		somaticseq_call.sh $T_BAM $N_BAM $OUTPUT_prefix.v1.call $ACTION $Nthreads $BED 


		# execute time : 2019-04-08 10:07:33 : train 
		somaticseq_call.train.sh $T_BAM $N_BAM $OUTPUT_prefix.v2.train $ACTION $Nthreads synthetic_snvs.vcf synthetic_indels.leftAlign.vcf $BED 


		# execute time : 2019-04-08 13:21:33 : predict
		somaticseq_call.predict.sh $T_BAM $N_BAM $OUTPUT_prefix.v3.predict $ACTION $Nthreads $OUTPUT_prefix.v2.train/SomaticSeq/Ensemble.sSNV.tsv.ntChange.Classifier.RData $OUTPUT_prefix.v2.train/SomaticSeq/Ensemble.sINDEL.tsv.ntChange.Classifier.RData $BED


else

		usage "/asolute/path/Tumor.bam /absolute/path/Normal.bam OUTPUT_prefix [echo|qsub] [Nthreads:1] [inclusion-bed:SSV3]"
fi
