perl -MMin -ne'
if($ARGV=~/_001.fastq.log$/ && /Processed reads:\s+(\d+)/){
	$total = $1;
	$ARGV =~ /(\w+)_AAAA/;
	$id=$1;
	$h{$id}{total}=$total;
}elsif($ARGV =~ /align_summary.txt$/){
	if(/Input:\s+(\d+)/){
		$h{$id}{"1st.input"} = $1;
		$h{$id}{"1st.input.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
	}elsif(/Mapped:\s+(\d+)/){
		$h{$id}{"1st.mapped"} = $1;
		$h{$id}{"1st.mapped.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
	}elsif(/of these:\s+(\d+)/){
		$h{$id}{"1st.mapped.multiple"} = $1;
		$h{$id}{"1st.mapped.multiple.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;

	}
}elsif($ARGV =~ /unmapped_remap.bam.flagstats$/){
	if(/(\d+) \+ 0 in total/){
		$h{$id}{"2nd.mapped"} = $1;
		$h{$id}{"2nd.mapped.%"} = sprintf "%.2f", $1/$h{$id}{total}*100;
	}
}
}{ 
		
$h{$id}{"total.mapped"} = $h{$id}{"1st.mapped"} + $h{$id}{"2nd.mapped"};
$h{$id}{"total.mapped.%"} = sprintf "%.2f",  $h{$id}{"total.mapped"} / $h{$id}{total}*100;
mmfss("$id.MappedReads", %h)' `find | egrep "(R1_001.fastq.log|unmapped_remap.bam.flagstats|align_summary.txt)"$ | sort`

