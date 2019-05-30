#!/bin/bash

. ~/.bash_function


if [ -f "$1" ];then
	
	JOB=CountHet
	vcf.sample.sh $1 | perl -snle'print join "\t", $job_name, $_, $file, $c++' -- -file=$1 -job_name=$JOB > args_table 
	
	batch.SGE2.args_table.sh $src/CountHetGenoFromVCF.sh args_table | sh 
	waiting $JOB

	# execute time : 2018-07-10 09:00:21 : make merged file
	perl -F"\t" -MMin -ane'chomp@F; $k=join "\t", @F[0..2]; $ARGV=~s/.bed.cnt//; $h{$k}{$ARGV}=$F[3] }{ mmfss("merge",%h)' *.bed.cnt 


	# execute time : 2018-07-10 09:00:35 : add header
	AddHeader.sh merge.txt Merge.txt chr start end $(head -1 merge.txt | cut -f2- )


else

	usage "XXX.vcf"

fi

