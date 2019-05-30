#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

GENOME="hg19" # "b37"

BAM=$1
IN=$2
BED=$3
VCF=$4



perl -F'\t' -asnle'
BEGIN{
	$genome     = $genome;
	$target_bed = $bed;
	$target_vcf = $vcf;
	$target_bam = $bam;

        print "new";
	print "genome $genome";
	print "load $target_bed" if $target_bed;
	print "load $target_bam" if $target_bam;
	print "load $target_vcf" if $target_vcf;
	print "snapshotDirectory $ENV{PWD}"
}

$pos = "$F[0]:$F[1]-$F[2]";

$pos2 = "$F[0].$F[1]-$F[2]";
$pos2 .= ".$F[3]" if $F[3];

print join "\n", "goto $pos", "sort base", "collapse", "snapshot $target_bam.$pos2.png";

}{ print "exit"
' -- -genome=$GENOME -bam=$BAM -bed=$BED -vcf=$VCF $IN  > $IN.igv.batch

echo "/home/adminrig/src/IGV_2.1.28/igv.sh $BAM -g $GENOME -b $IN.igv.batch"

echo "`date`check the xming"

/home/adminrig/src/IGV_2.1.28/igv.sh $BAM -g $GENOME -b $IN.igv.batch

else
	usage "XXX.bam YYY.bed[target point to capture] [target.bed] [target.vcf]"
fi

