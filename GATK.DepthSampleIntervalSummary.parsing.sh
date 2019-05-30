#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	perl -F'\t' -MPDL -MList::MoreUtils=natatime -anle'
	
	($target,$total_depth,$avg_depth)=@F[0..2];

#map { print "[$_]\t $F[$_]" } 0 .. $#F;
#exit;
	my @list=();
	$it = natatime 25, @F[3..$#F];
	while ( @vals = $it->() ){
		($id,@tmp)=@vals;
		push @list, $id
	}

#map { print } @list;
	if($.==1){
		print join "\t", $target,$total_depth,$avg_depth,"mean","sddev",@list
	}else{
		$piddle = pdl @list;
		($mean,$prms,$median,$min,$max,$adev,$rms) = statsover $piddle;
		$mean = sprintf "%0.2f", $mean;
		$adev = sprintf "%0.2f", $adev;

		print join "\t", $target,$total_depth,$avg_depth,$mean,$adev,@list;
	}
	' $1 > $1.PerSample 

else
	usage "XXXX..report.sample_interval_summary"
fi



#Target  total_coverage  average_coverage        DNALink.PE.VP06139_total_cvg    DNALink.PE.VP06139_mean_cvg     DNALink.PE.VP06139_granular_Q1  DNALink.PE.VP06139_granular_median      DNALink.PE.VP06139_granular_Q3  DNALink.PE.VP061_
#1:9323910       8453    8453.00 60      60.00   61      61      61      100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     4
#1:9324213       3259    3259.00 26      26.00   27      27      27      100.0   100.0   100.0   100.0   100.0   0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     2
#1:108185301     8528    8528.00 77      77.00   78      78      78      100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   100.0   0.0     0.0     0.0     0.0     0.0     5
#1:151820324     5781    5781.00 39      39.00   40      40      40      100.0   100.0   100.0   100.0   100.0   100.0   100.0   0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0     3
#
