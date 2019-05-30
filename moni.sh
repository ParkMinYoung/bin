#!/bin/sh

. ~/.bash_function

if [ $# -eq 1 ];then

		QUERY=$1
		qstat -f -u '*' | grep -v -w -e qw -e hqw > qstat.tmp

		TOTAL=$(grep $QUERY -c qstat.tmp)
		echo "=============================================="
		echo "Total Number of Jobs Task For $QUERY : $TOTAL"
		echo "=============================================="

		echo "====================================="
		grep $QUERY qstat.tmp | awk '{print $3}' | sort | uniq -c | sort -t"_" -n -k2,2 | awk '{print $2"\t"$1}'
		echo "====================================="


		echo "=========================================================================="
		perl -MMin -snle'if(/(.+\@.+)\s+/){ $node=$1 }elsif(/$query/){ $h{$node}++ } }{ h1c(%h) ' -- -query=$QUERY qstat.tmp
		echo "=========================================================================="

		rm -rf qstat.tmp
else
		usage "JOB_NAME_PATTERN"
fi

