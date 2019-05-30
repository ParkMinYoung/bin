#!/bin/bash

. ~/.bash_function

if [ $# -eq 3 ] && [ -f "$1" ] && [ -f "$2" ];then

# https://gatkforums.broadinstitute.org/gatk/discussion/6308/evaluating-the-quality-of-a-variant-callset
#-eval GATK.output.vcf
#-comp Trueset.vcf

	GATK_VCF=$1
	TRUESET_VCF=$2
	OUTPUT=$3

	# execute time : 2018-07-23 17:42:02 : 
	/home/adminrig/src/java/jre1.7.0_25/bin/java -Xmx64g -Djava.io.tmpdir=/state/partition1/tmp -jar /home/adminrig/src/GATK.3/GATK3.5/GenomeAnalysisTK.jar \
	-T VariantEval \
	-R /home/wes/src/GATK/resource_bundle/latest/b37/human_g1k_v37.fasta \
	-eval $GATK_VCF \
	-comp $TRUESET_VCF \
	-o $OUTPUT \
	-EV ValidationReport 
#	-EV GenotypeConcordance

 perl -F'\s+' -anle'if(/^(CompOverlap|ValidationReport)/){ if(/CompRod/){ push @head, @F }elsif(/all/){ push @cont, @F } } }{ print join "\t", @head; print join "\t", @cont ' $OUTPUT > $OUTPUT.tab

else	
	usage "GATK_VCF TRUESET_VCF OUTPUT"
fi

