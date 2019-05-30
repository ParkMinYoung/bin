#!/bin/sh
#for i in $@;do echo $i && qsub -N FastInfo.$(echo $i | cut -c1-4) ~/src/short_read_assembly/bin/sub GetFastqInfo.sh $i && sleep 10 ;done

source ~/.bash_function

if [ $# -ne 0 ];then

	for i in $@;do echo $i && qsub -N sub.work ~/src/short_read_assembly/bin/sub GetFastqInfo.sh $i && sleep 10 ;done
	#for i in $@;do echo $i;done 

	 perl -le'while($l=`qstat -u adminrig`){ $l=~/sub\.work/ ? sleep 10 : print localtime()." " & exit}'
	 GetQualityScoreDist.Collect.sh
	 Cols2Matrix.sh 6 Means `find | grep stats.txt$`
	 #find | grep s_._1_sequence.txt.gz.num$ | sort | xargs cat > reads.summary
	 find | grep num$ | sort | xargs cat > reads.summary
else
	usage try.fastq{.gz}....	
fi 

