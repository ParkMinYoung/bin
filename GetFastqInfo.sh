#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

		DIR="$1.info"
		mkdir $DIR

		EXT=$(perl -sle'$f=~/\.(\w+)?$/;print $1' -- -f=$1)
		if [ $EXT == "gz" ];then
			zcat $1 | fastx_quality_stats -Q33 -o $1.stats.txt
			(echo -ne "$1\t"; zcat $1 | wc -l | awk '{print $1/4}') > $1.num
		else
			fastx_quality_stats -i $1 -o $1.stats.txt
			wc -l $1 | awk '{print $2"\t"$1/4}' > $1.num
		fi

		fastq_quality_boxplot_graph.sh -i $1.stats.txt -o $1.quality.png
		fastx_nucleotide_distribution_graph.sh -i $1.stats.txt -o $1.nuc.png 
		GetQualityScoreDist.sh $1

		mv $1.stats.txt $1.quality.png $1.nuc.png $1.Qscore $1.num $DIR

else
		usage try.fastq{.gz}
fi

