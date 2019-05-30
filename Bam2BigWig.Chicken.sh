#!/bin/sh
REF=/home/adminrig/Genome/Chicken/galGal3.genome
genomeCoverageBed -bg -ibam $1 -g $REF > $1.bedgraph
bedGraphToBigWig $1.bedgraph $REF $1.bedgraph.bw
