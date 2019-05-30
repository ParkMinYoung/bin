#!/bin/sh
REF=/home/adminrig/Genome/Mouse/mm10/mm10.genome
genomeCoverageBed -bg -ibam $1 -g $REF > $1.bedgraph
bedGraphToBigWig $1.bedgraph $REF $1.bedgraph.bw
GetUCSCUrl.mm10.sh $1
