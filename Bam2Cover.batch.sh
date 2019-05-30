#!/bin/sh


source $HOME/.bash_function

if [ -f "$1" ];then
	for i in $@;do echo -e "qsub -N Bam2Cover ~/src/short_read_assembly/bin/sub Bam2Cover.sh $i\nsleep 20";done
else
    usage [bam file list]
fi
