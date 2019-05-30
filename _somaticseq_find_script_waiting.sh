#!/bin/bash

. ~/.bash_function

if [ $# -ge 1 ];then

		PATTERN=$( echo $@ | tr "\n" " " | sed 's/ $//' | tr " " "|" )
		#echo $PATTERN
		#egrep "($PATTERN)" try

		# somaticSeq mergeResult


		num=$$
		# execute time : 2019-04-03 16:57:38 : 
		#find | grep cmd$ | grep -e somaticSeq -e mergeResult | sort > script
		find $OUTPUT_DIR | grep cmd$ | egrep "($PATTERN)" | sort > script.$num


		# execute time : 2019-04-03 17:07:48 : 
		find $OUTPUT_DIR | grep cmd$ | perl -nle'/\/logs\/(.+?).\d{4}/;print $1' | sort | uniq | cut -c1-10 > jobs_list.$num


		# execute time : 2019-04-03 17:08:14 : 
		_waiting jobs_list.$num


		# execute time : 2019-04-03 17:08:14 : execute qusb and cleanup
		parallel -a script.$num qsub -sync y
		rm -rf jobs_list.$num script.$num


else

	usage "PATTERN1 PATTERN2...."
fi

