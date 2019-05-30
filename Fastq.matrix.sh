#!/bin/sh

#find Project_KNIH.set* | grep bam$ | egrep -v "(P|S)E" |
find -type f | grep N.fastq.gz$ | perl -MFile::Basename -MMin -ne'
($f,$d)=fileparse($_);
#$h{$d}{total}++ if $f=~/gz$/;
#$h{total}{total}++ if $f=~/gz$/;
/\.(\w+)?$/;
$h{$d}{$1}++;
}{
mmfss("Fastq.matrix",%h)'

# probeset_id     AddRG   Dedupping       IndelRealigner  TableRecalibration      gz      sorted
# Project_KNIH.set1/Sample_VP02226/       0       0       0       0       1       1
# Project_KNIH.set1/Sample_VP02696/       1       0       0       0       1       1
# Project_KNIH.set1/Sample_VP02952/       1       1       1       1       1       1
# Project_KNIH.set1/Sample_VP03160/       1       0       0       0       1       1
# Project_KNIH.set1/Sample_VP04173/       0       0       0       0       1       1
