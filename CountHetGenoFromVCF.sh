#!/bin/bash

. ~/.bash_function


if [ $# -ge 2 ] & [ -f "$2" ];then

		#ID=SPNT_012
		ID=$1
		BED=$ID.bed
		CNT=$BED.cnt

		VCF=$2
		ID=${3:-ID}



		cat $VCF | java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar filter " isHet(GEN[$ID]) " - | java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar extractFields - CHROM POS ID GEN[$ID].DP | perl -F"\t" -anle'print join "\t", $F[0], $F[1]-1, $F[1], $F[3] if $.>1 ' > $BED

		bedtools intersect -a /home/adminrig/src/short_read_assembly/bin/dependancy/human.genome.1Mb.bed -b $BED -c > $CNT


else
	
	usage "Sample_ID VCF [ Sample_Order(Number 0,1,2...) ]"
fi



