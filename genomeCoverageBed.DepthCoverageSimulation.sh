#!/bin/sh


. ~/.GATKrc
. ~/.bash_function


if [ -f "$1" ];then

#SureSelectNUMBED=/home/adminrig/Genome/SureSelect/HumanKinome.V1/BED/029263_D_BED_20111101.NumChr.bed
SureSelectNUMBED=$1

PID=$$
#for i in `ls *.bam`;do echo "genomeCoverageBed.CreateRegionOverXDepth.sh $i $SureSelectNUMBED &";done | perl -nle'print;print "wait" if $.%16==0' > 00.genomeCoverageBed.CreateRegionOverXDepth

batch.SGE.ARGV.sh genomeCoverageBed.CreateRegionOverXDepth.sh $SureSelectNUMBED `ls *bam` > 00.genomeCoverageBed.CreateRegionOverXDepth
batch.chagename.sh G$PID 00.genomeCoverageBed.CreateRegionOverXDepth
sh 00.genomeCoverageBed.CreateRegionOverXDepth

waiting G$PID

for i in 1 5 10 15 20 25 30
	do
	DIR=DP$i
	cd $DIR 
	Bed2Intersect.sh `ls *merge.bed`
	coverageBedV2.sh intersect.bed $SureSelectNUMBED
	coverageBed.summaryV2.sh intersect*merged.bed.coverage 
	cd ..
		
done

perl -nle'/=(\d+):(\d+):(.+)/; print join "\t", $ARGV,$1,$2,$3' `find DP*  | grep coverage.out$` > Intersect.Cov2DP
perl -MMin -ne'$ARGV=~/(DP\d+)/;$h{$ARGV}{DP}=$1;/(\d+):(\d+):(.+)/;$h{$ARGV}{Exp}=$1;$h{$ARGV}{Target}=$2;$h{$ARGV}{SeqCov}=$3 }{ mmfss("IntersectCov2Depth",%h)' `find DP* | grep coverage.out$ | grep -v -i intersect`
perl -MMin -ne'$ARGV=~/(DP\d+)/;$h{$ARGV}{DP}=$1;/(\d+):(\d+):(.+)/;$h{$ARGV}{Exp}=$1;$h{$ARGV}{Target}=$2;$h{$ARGV}{SeqCov}=$3 }{ mmfss("Intersect2Cov2Depth",%h)' `find DP* | grep coverage.out$ | grep -i intersect`
perl -MMin -ne'$ARGV=~/(DP\d+)\/(.+)_\w{6}_/;($depth,$ID)=($1,$2);/(\d+):(\d+):(.+)/;$h{$ID}{$depth}=$3 }{ mmfss("Intersect3Cov2Depth",%h)' `find DP* | grep coverage.out$ | grep -i -v intersect`



perl -F'\t' -MMin -ane'chomp@F;$ARGV=~/(DP\d+)/; $h{$F[0]}{$1}=$F[1];$h{$F[0]}{Exp_len.".$1"}=$F[2];$h{$F[0]}{total}=$F[3] }{ mmfss("Intersect.Gene.Cov",%h)'  `find DP* | grep intersect | grep coverage.txt$ `

else
	usage "XXX.bed"
fi

