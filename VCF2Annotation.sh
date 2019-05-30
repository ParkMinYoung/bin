#!/bin/sh

. ~/.bash_function
. ~/.perl

FILE=$1

ABS=$(fullpath $FILE)
NAME=$(basename $ABS)
DIR="Annotation/$NAME"

if [ ! -d $DIR ];then
	mkdir -p $DIR
fi

if [ -d $DIR ];then

	echo "`date` START $ABS";

	ln $ABS $DIR
	cd $DIR
	
	GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $NAME >& $NAME.GRCh37.66.vcf.log

	AnnoVar.Annotation.sh $NAME.GRCh37.66.vcf 
	AnnoVar.Annotation.post1.sh
#AnnoVar.VarScanMergeAnnotation.Format.sh $NAME

fi



