PID=$$
batch.SGE.sh ReadStatistics.ToAdd.sh `find Sample_* | grep mergelanes.bam$` > 01.ReadStatstics 
batch.chagename.sh S$PID 01.ReadStatstics 
sh 01.ReadStatstics

waiting S$PID
StatisticsReport.summary.V2.sh


