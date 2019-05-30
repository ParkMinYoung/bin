find | grep "\.StatisticsReport"$ | perl -nle'
if( /.Mark.MarkDuplicatesMetrics.StatisticsReport$/ ){
	print "$_";
}else{
	/(.+ner.bam)\..+/;
	$file = "$1.Mark.MarkDuplicatesMetrics.StatisticsReport";
	print "mv $_ $file";
}'



