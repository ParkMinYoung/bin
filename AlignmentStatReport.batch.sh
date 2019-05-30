PID=$$        
batch.SGE.sh AlignmentStatisticsReport.Wrapper.sh `find | grep ner.bam$ | sort` > 06.AlignmentStat
batch.chagename.sh S$PID 06.AlignmentStat
sh 06.AlignmentStat
waiting S$PID
StatisticsReport.summary.sh

