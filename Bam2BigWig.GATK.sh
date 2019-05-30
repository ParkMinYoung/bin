#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
GATK_param

genomeCoverageBed -bg -ibam $1 -g $REF_GENOME > $1.bedgraph
perl -i.bak -ple's/^/chr/ if !/^chr/' $1.bedgraph
bedGraphToBigWig $1.bedgraph $REF_GENOME $1.bedgraph.bw
GetUCSCUrl.sh $1

