#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

if [ -f "$1" ] ;then

	 T=$2
#D=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed
#D=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.merged.NumChr.bed
#D=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed.merged.NumChr.bed
	 Target=${T:=$SureSelectNUMBED}
	 Name=$(basename $Target)
	
	 IN=$(basename $1)

	echo "Target : $Target"
	echo "Input  : $1"

	 coverageBed -a $1 -b $Target > $IN.$Name.coverage
	 SequencingCov.sh $IN.$Name.coverage > $IN.$Name.coverage.out
	#coverageBed -hist -abam $1 -b $Target > $1.$Name.coverage 

else
	usage "XXX.bed target.bed[SureSelectV2]"
fi


# if use -hist                                           depth cover bp  length   cover bp percent
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    106     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    108     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    109     4       240     0.0166667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    110     1       240     0.0041667
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    111     2       240     0.0083333
# X       200797  201037  entg|PLCXD1:ccds|CCDS14103.1    112     1       240     0.0041667

