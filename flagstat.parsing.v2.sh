perl -MMin -ne'
if(/^(\d+) \+ \d (.+?)($| \()/){
	
	$h{$2}{$ARGV} = $1;
	$title = $2;
	if(/mapQ/){
		$h{"duplicates%"}{$ARGV} = sprintf "%.2f", $h{duplicates}{$ARGV}/$h{mapped}{$ARGV}*100;
		$h{"mapped%"}{$ARGV} = sprintf "%.2f", $h{mapped}{$ARGV}/$h{"in total"}{$ARGV}*100;
	}
	
}

}{ mmfss("flagstats",%h)' $@
#}{ mmfss("flagstats",%h)' `find | grep flagstats$`



 # 159060650 + 0 in total (QC-passed reads + QC-failed reads)
 # 0 + 0 duplicates
 # 128670737 + 0 mapped (80.89%:nan%)
 # 159060650 + 0 paired in sequencing
 # 79530325 + 0 read1
 # 79530325 + 0 read2
 # 120917628 + 0 properly paired (76.02%:nan%)
 # 124983652 + 0 with itself and mate mapped
 # 3687085 + 0 singletons (2.32%:nan%)
 # 3043173 + 0 with mate mapped to a different chr
 # 1830920 + 0 with mate mapped to a different chr (mapQ>=5)
