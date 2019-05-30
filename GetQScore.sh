#!/bin/sh

## GA Solexa fastq > 1.3 ord( ASCII ) - 64
for i in `find s_? | grep s_[1-8].[12].fastq$`;do echo $i && qsub -N Qscore.$(echo $i | cut -c1-3) ~/src/short_read_assembly/bin/sub GetQualityScoreDist.sh $i && sleep 10;done 

## Sanger fastq  ord( ASCII ) - 33
# perl -nle'map { $h{$_}++ } split "" if $.%4==0 }{ map { print join "\t", ord($_)-33, $_, $h{$_} } sort {ord($a)<=>ord($b)} keys %h' s_1.1.ReadFilter.sanger.fastq
