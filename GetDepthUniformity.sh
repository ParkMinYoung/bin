perl -F'\t' -MMin -ane' 
chomp@F;
if($ARGV=~/\/(.+).mergelanes.dedup.+.sample_summary$/){
	$id = $1;
	if(/^(sample|Total)/){
		
		next;
	}else{
		$h{$id}{Mean}  = $F[2];
		$h{$id}{Total} = $F[1];
	}
}elsif($ARGV=~/\/(.+).mergelanes.dedup.+.coverage_counts$/){
		$id = $1;
	if(/^NSample/){
		$mean = $h{$id}{Mean};

		$mean_20per = int( $mean * 0.2 );
	

		$coverage = $F[$mean_20per - 1];
		$h{$id}{Uniformity_depth} = $mean_20per;
		$h{$id}{Uniformity_percent} = $coverage / $F[1] * 100;
	}
} 
}{ mmfss("out", %h)
'  `find | grep -e dedup.bam.target.depthofcov.sample_cumulative_coverage_counts$ -e dedup.bam.target.depthofcov.sample_summary$ | sort -r`

