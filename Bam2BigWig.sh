#!/bin/sh
G=/home/adminrig/workspace.min/IonTorrent/IonTorrentDB/hg19.genome
G=/home/adminrig/Genome/hg19.bwa/hg19.genome
genomeCoverageBed -bg -ibam $1 -g $G > $1.bedgraph
bedGraphToBigWig $1.bedgraph $G  $1.bedgraph.bw
