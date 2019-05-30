#!/bin/sh

REFG=~/Genome/hg19Fasta/refGene.bed

# for i in `find s_? | grep s_..bam$`;do echo "GetBedOverDepth.sh $i 30 $REFG &";done | sh 
for i in $@ ;do echo "GetBedOverDepth.sh $i 30 $REFG &";done | sh 

perl -F'\t' -MMin -ane'$ARGV=~/(s_\d).+(Depth\.\d+)/;
$dep="$1.$2";
chomp@F;
if(/^probeset/){next}
else{
    $symTabref="$F[5]\t$F[0]\t$F[1]\t$F[3]";
    $h{$symTabref}{$dep}=$F[4];
}
}{ mmfss("depth.summary",%h)' `find | grep gene`

