#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

GENOME="mm10" # "b37"

N_BAM=$1
T_BAM=$2
TARGET_BED=$3
IN=$4

OUT=$IN.IGV
mkdir -p $OUT

perl -F'\t' -asnle'
BEGIN{
	$genome     = $genome;
	$target_bed = $bed;

    print "new";
	print "genome $genome";
	print "load $target_bed" if $target_bed;
	print "load $N_BAM" if $N_BAM;
	print "load $T_BAM" if $T_BAM;
	print "snapshotDirectory $ENV{PWD}/$outdir"
}

$pos = "$F[0]:$F[1]-$F[2]";

$pos2 = "$F[0].$F[1]-$F[2]";
$pos2 = "$F[3].$pos2" if $F[3];

print join "\n", "goto $pos", "sort base", "collapse", "snapshot $pos2.png";

}{ print "exit"
' -- -genome=$GENOME -N_BAM=$N_BAM -T_BAM=$T_BAM -bed=$TARGET_BED -outdir=$OUT $IN  > $IN.igv.batch

echo "/home/adminrig/src/IGV_2.1.28/igv.sh $BAM -g $GENOME -b $IN.igv.batch"

echo "`date`check the xming"

/home/adminrig/src/IGV_2.1.28/igv.sh -g $GENOME -b $IN.igv.batch

else
	usage "Normal.bam Tumor.bam Designed.bed mutation.spot.bed"
fi

