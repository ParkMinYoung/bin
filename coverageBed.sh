#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] ;then

	 T=$2
	 D=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.NumChr.bed
	 Target=${T:=$D}
	 Name=$(basename $Target)
	 
	 coverageBed -abam $1 -b $Target > $1.$Name.coverage
	 SequencingCov.sh $1.$Name.coverage > $1.$Name.coverage.out
	#coverageBed -hist -abam $1 -b $Target > $1.$Name.coverage 

else
	usage "sorted.bam target.bed[SureSelectV2]"
fi


# if use -hist                                           depth cover bp  length   cover bp percent
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    106     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    108     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    109     4       240     0.0166667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    110     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    111     2       240     0.0083333
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    112     1       240     0.0041667

