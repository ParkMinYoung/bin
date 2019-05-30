#!/bin/bash

. ~/.bash_function

if [ -d "$1" ] && [ $# -eq 3 ]; then

	WES_DIR=$1
	WES_VERSION=$2
	OUT_DIR=$3

	# execute time : 2018-11-19 10:42:50 : make folder
	mkdir -p $OUT_DIR/Depth


	# execute time : 2018-11-19 10:53:26 : make GATK Summary
	(cd $OUT_DIR  && GATK3.Summary.sh $WES_DIR $WES_VERSION)


	# execute time : 2018-11-19 11:31:03 : Depth Summary
	(cd $OUT_DIR/Depth && find $WES_DIR/Sample_*/ -maxdepth 1 -name "*.sample_interval_summary" | xargs -P5 -n 1 -i GATK3.sample_interval_summary2bed.sh {}  ) 


	# execute time : 2018-11-19 11:33:50 : merge Depth Summary
	(cd $OUT_DIR && AddRow.w.sh DepthOfCoverage '\/(.+).mergelane' ID $(find Depth | grep bed$) | grep AddRow | sh )


	# execute time : 2018-11-19 13:00:01 : add NDP
	perl -F'\t' -anle' if(@ARGV){ $h{$F[0]}=$F[25]; }else{ if(!$c++){ print join "\t", $_, "NDP"}else{ print join "\t", $_, $F[3]/$h{$F[4]} }}  ' $OUT_DIR/Summary.txt $OUT_DIR/DepthOfCoverage > $OUT_DIR/DepthOfCoverage.NDP


else
	echo -e "\n\n$0 /dlst/wes/workspace.krc/20181029_DNALink_Twist/V7 SSV7 output_dir" 
	echo -e "$0 /dlst/wes/workspace.krc/20181029_DNALink_Twist/Twist Twist out_Twist\n\n" 
	usage "WES_DIR WES_VERSION OUT_DIR"

fi
