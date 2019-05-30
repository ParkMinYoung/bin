#!/bin/sh


. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then

		GENOME=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.genome
		## make shared bam file against target region
		#intersectBed -abam $1 -b ~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed -wa > $1.InTarget.bam
		#intersectBed -abam $1 -b /home/adminrig/workspace.min/KNIH.Coverage.Samples200.20120504/BRCA.bed -wa > $1.InTarget.bam
		intersectBed -abam $1 -b $2 -wa > $1.InTarget.bam

		## make bedgraph
		genomeCoverageBed -bg -ibam $1.InTarget.bam -g $GENOME > $1.InTarget.bam.bedgraph

		## make bedgraph.bw
		bedGraphToBigWig $1.InTarget.bam.bedgraph $GENOME $1.InTarget.bam.bedgraph.bw

else
	usage "xxx.bam target.bed"
fi

