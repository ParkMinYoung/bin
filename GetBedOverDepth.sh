#!/bin/sh


REF=~/Genome/hg19Fasta/hg19.fasta
REFG=~/Genome/hg19Fasta/hg19.genome


source ~/.bash_function

if [ $# -eq 3 ] && [ -f "$1" ] && [ -f "$3" ] ;then
	
	## filter ##
	# samtools view -q 10 -f 0x2 -b 1.bam > 1.clean.bam

	# -q     : mapping quality >= 10
	# -f 0x2 : properly pair
	# -b     : output format
	# -o     : output name
	


	FILTER=$1.bedg.flt.Depth.$2.bed

	genomeCoverageBed -ibam $1 -g $REFG -bga > $1.bedg
	
	awk '{if ($4>=1) print}' $1.bedg | mergeBed -i stdin > $1.Depth.1.bed
	awk -v dep="$2" 'BEGIN{FS="\t"}{if ($4>=dep) print}' $1.bedg | mergeBed -i stdin > $FILTER
	coverageBed -a $FILTER -b $3 > $FILTER.coverage	
	
	## using pipe ##

	#genomeCoverageBed -ibam $1 -g $REFG -bga | \
	#tee $1.bedg | \
	#awk -v dep="$2" 'BEGIN{FS="\t"}{if ($4>=dep) print}' | \
	#mergeBed -i stdin > $FILTER
	
	#coverageBed -a $FILTER -b $3 > $FILTER.coverage	
	
	CoverageBed.output.summary.sh $FILTER.coverage

else
	echo "for i in \`find s_? | grep s_..bam$\`;do echo \"./GetBedOverDepth.sh \$i 30 refGene.bed &\";done"
	usage "input.bam 30 shared.bed"
	# ./GetBedOverDepth.sh s_1/s_1.bam 30 refGene.bed
	# 1 : input bam file
	# 2 : filtered depth 
	# 3 : shared bed file 

fi

