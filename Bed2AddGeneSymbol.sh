#!/bin/bash

. ~/.bash_function


if [ -f "$1" ];then

		OUTPUT=${1%.bed}

		# execute time : 2018-08-20 13:37:51 : step1 : make merged bed
		Bed2MergeBed.sh $1 


		# execute time : 2018-08-20 13:42:07 : step2: get gene list
#		GetGeneBedFromUCSCrefFlat.sh
		GetGeneBedFromUCSCrefFlat.sh refFlat.txt 


		# execute time : 2018-08-20 13:52:24 : step3: add Gene Symbol
		bedtools intersect -a $OUTPUT.merged.bed -b refFlat.Gene.bed -wa -wb | cut -f1-3,7 > $OUTPUT.Gene.bed
		sed 's/^chr//' $OUTPUT.Gene.bed >  $OUTPUT.Gene.rm_chr.bed


		# execute time : 2018-08-20 13:55:50 : gene count
		cut -f4 $OUTPUT.Gene.bed | uniq_cnt_e_desc | sed '1 i\Gene\tCount' > $OUTPUT.Gene.bed.Gene_Count

else
		
		usage "BED(including chr version)"

fi
