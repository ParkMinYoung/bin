#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

		ls *bam  | \
				perl -nle'/(.+).mergelanes/; print "/home/adminrig/src/ngsplot/2.47/ngsplot/bin/ngs.plot.r -G mm10 -R genebody -C $_ -O $1 -T $1 -D refseq -L 4000 -FL 300 -LEG 0 &"; print "wait" if $.%4==0 ' > PerSample.sh
		echo wait >> PerSample.sh

		sh PerSample.sh 


		# Normlization NGSPlot Per Sample
		perl -F'\t' -anle'/^(.+).mergelanes/; print "/home/adminrig/src/ngsplot/2.47/ngsplot/bin/ngs.plot.r -G mm10 -R genebody -C $F[0]:$F[1] -O $1.vs.Input -T $1.vs.Input -D refseq -L 4000 -FL 300 -LEG 0 &"; print "wait" if $.%4==0' $1 > PerPair.sh
		echo wait >> PerPair.sh

		sh PerPair.sh


		pdf2png.batch.sh


		mkdir Genebody &&  mv `ls *png | grep avg` Genebody/

else
		usage "Pairs"
fi
