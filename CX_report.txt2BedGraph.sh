#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	#ID=$(perl -le'$ARGV[0]=~/(.+)_\w{6,8}_L00/; print $1 ' $1)
	ID=$(perl -le'$ARGV[0]=~/(.+)\//; print $1 ' $1)

	perl -F"\t" -asnle'
	BEGIN{
		print "track type=bedGraph name=\"$sample_id\" description=\"$sample_id\" color=143,246,150 visibility=full yLineOnOff=on autoScale=on yLineMark=\"0.0\" alwaysZero=on graphType=bar maxHeightPixels=128:75:11 windowingFunction=maximum smoothingWindow=off"
	}
	$s=$F[1]-1; 
	$sum= $F[3]+$F[4]; 
	
	if($sum>0 && !/^GL/){ 
		$meth = sprintf "%0.2f", $F[3]>0 ? $F[3]/$sum : 0 ;
		$chr="chr$F[0]"; 
		$chr=~s/MT/M/; 
		print join "\t", $chr, $s, $F[1], $meth 
	}
	' -- -sample_id=$ID $1 

else	

	usage "DMSO1_re1_AACGTGAT_L006_R1_001_bismark_bt2_pe.deduplicated.CX_report.txt"

fi


