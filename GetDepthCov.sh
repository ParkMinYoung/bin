#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ -f "$1" ] ;then

	T=$2
	Target=${T:=$SureSelectNUMBED}
	Name=$(basename $Target)
	 
	coverageBed -abam $1 -b $Target -hist > $1.hist
	DepthCovCalc.WGS.sh $1.hist


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

