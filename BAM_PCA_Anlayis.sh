#!/bin/bash

. ~/.bash_function

if [ -d "$1" ];then


	BAM_DIR=$1
	NumOfThreads=${2:-10}

#	--region chr10 or --region chr10:456700:891000


	# execute time : 2018-11-15 22:11:54 : calc coverage by binning 10K 
	/root/miniconda2/bin/multiBamSummary bins --bamfiles $(ls $BAM_DIR/*bam | sort | tr "\n" " ") --labels $(ls $BAM_DIR/*bam | sort | perl -nle'/\/(.+).mergelanes/;print $1' | tr "\n" " ") --ignoreDuplicates --minMappingQuality 10 -out readCounts.npz --outRawCounts readCounts.tab --numberOfProcessors $NumOfThreads 



	# spearman correlation
	/root/miniconda2/bin/plotCorrelation -in readCounts.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers --plotFileFormat pdf -o heatmap_SpearmanCorr_readCounts.pdf --outFileCorMatrix SpearmanCorr_readCounts.tab --labels $(head -1 readCounts.tab | cut -f4- | tr "\t" " " | sed s/"'"/""/g ) --plotWidth 20 --plotHeight 20


	# pearson correlation
	/root/miniconda2/bin/plotCorrelation -in readCounts.npz --corMethod pearson --skipZeros --plotTitle "pearson Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers --plotFileFormat pdf -o heatmap_pearson_readCounts.pdf --outFileCorMatrix pearsonCorr_readCounts.tab --labels $(head -1 readCounts.tab | cut -f4- | tr "\t" " " | sed s/"'"/""/g ) --plotWidth 20 --plotHeight 20



	# PCA
	/root/miniconda2/bin/plotPCA -in readCounts.npz --plotFileFormat pdf -o PCA_readCounts.pdf --plotTitle "PCA of Read Counts" --labels $(head -1 readCounts.tab | cut -f4- | tr "\t" " " | sed s/"'"/""/g ) --plotWidth 10 --plotHeight 10




else
	
	usage "BAM_DIR [Num of Threads:10]"

fi



