#!/bin/sh

. ~/.bash_function

if [ -f $1 ]; then

WGS_BIN=/home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/bin.1k.bed
R=/home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/chr.mean_dp.1sample.R
REFFLAT=/home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/refFlat.txt.Gene.bed

coverageBed -abam $1 -b $WGS_BIN > $1.coverage
perl -F'\t' -anle'if($.==1){print join "\t",  qw/interval chr start end mean_dp/} print join "\t", "$F[0]:$F[1]-$F[2]", @F[0..3]' $1.coverage > $1.coverage.table

#for i in *coverage; do perl -F'\t' -anle'if($.==1){print join "\t",  qw/interval chr start end mean_dp/} print join "\t", "$F[0]:$F[1]-$F[2]", @F[0..3]' $i > $i.table; done
R CMD BATCH --no-save --no-restore '--args $1.coverage.table $1.coverage.table.out' $R

coverageBed -abam $1 -b $REFFLAT > $1.$(basename $REFFLAT).coverage

else

	usage "xxx.bam"
fi

 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/refFlat.txt.Gene.bed
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/chr.bin.sh
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/readme
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/hg19.genome
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/refFlat.txt
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/chr.mean_dp.1sample.R
 ## /home/adminrig/workspace.min/IonTorrent/IonProton/bin/DB/bin.1k.bed

