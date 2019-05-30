# excute time : 2016-10-05 11:01:13 : make link
# ln -s `find /wes/CHIPseq/20160401_knumc_ParkYongjae_1/ | grep recal.bam$ ` ./ 


# excute time : 2016-10-05 11:03:35 : make pair file
ls *bam | sort | paste - - > Pair 

# NGSPlot Per Sample
ls *bam  | perl -nle'/(.+?).mergelanes/; print "/home/adminrig/src/ngsplot/2.47/ngsplot/bin/ngs.plot.r -G mm10 -R genebody -C $_ -O $1 -T $1 -D refseq -L 4000 -FL 300 -LEG 0 &"' > PerSample.sh
 sh PerSample.sh 
#
#
# # Normlization NGSPlot Per Sample
perl -F'\t' -anle'/^(.+?).mergelanes/; print "/home/adminrig/src/ngsplot/2.47/ngsplot/bin/ngs.plot.r -G mm10 -R genebody -C $F[0]:$F[1] -O $1.vs.Input -T $1.vs.Input -D refseq -L 4000 -FL 300 -LEG 0 &"' Pair > PerPair.sh
echo  "wait" >> PerPair.sh
sh PerPair.sh

#
pdf2png.batch.sh

#
mkdir Genebody &&  mv `ls *png | grep avg` Genebody/

# excute time : 2016-10-05 13:21:35 : rename
cd Genebody && rename .avgprof.pdf "" *.png
	

