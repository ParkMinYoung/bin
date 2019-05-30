#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

BAM=$1
BAM_dup=$BAM.dup.bam
samtools view -f 0x0400 $BAM -bo $BAM_dup
samtools view -h $BAM_dup | perl -F'\t' -MMin -asne'$h{length($F[9])}{$F[2]}++ }{ mmfsn("$f.dup.read.len",%h)' -- -f=$BAM_dup

else
		usage "XXX.bam"
fi


