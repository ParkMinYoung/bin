#!/bin/sh

. ~/.bash_function

ABS=$(fullpath $1)
NAME=$(basename $ABS)
DIR="Annotation/$NAME"

if [ ! -d $DIR ];then
	mkdir -p $DIR
fi

if [ -d $DIR ];then

	echo "`date` START $ABS";

	ln $ABS $DIR
	cd $DIR
	
	grep Somatic $NAME > $NAME.Somatic
	VarScan.output2VEP.sh $NAME.Somatic
	VEP2VCF.sh $NAME.Somatic.VEP.input
	GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $NAME.Somatic.VEP.input.vcf >& $NAME.Somatic.VEP.input.vcf.GRCh37.66.vcf.log
#!# Eff.OutParsing.sh $1.Somatic.VEP.input.vcf.GRCh37.66.vcf

	AnnoVar.Annotation.sh $NAME.Somatic.VEP.input.vcf.GRCh37.66.vcf 
	AnnoVar.Annotation.post1.sh
	AnnoVar.Annotation.Format.sh AnnoVarAnnotation.txt $NAME  
	VEP.sh $NAME.Somatic.VEP.input.vcf.GRCh37.66.vcf

fi



