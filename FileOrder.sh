#!/bin/sh

. ~/.bash_function

if [ $# -ge 2 ];then
ORDER=$1
shift

ls $@ | perl -snle'push @l, $_ }{ @order= split ",", $list; map {$_--} @order; print join " ", @l[@order]' -- -list="2,1,3"

else
	echo " ./FileOrder.sh \"2,1,3\" \`find | egrep \"(R1_001.fastq.log|unmapped_remap.bam.flagstats|.starLog.final.out)\"$ | sort\`"
	usage "\"2,1,3\" xxx yyy zzz [...]"
fi
