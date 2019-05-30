#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

		MergeSomaticIndelDetector.sh $@
		## output is MergeVarScanForVEP.input

		FILE=MergeSomaticIndelDetector.input

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
			
			VEP2VCF.sh $NAME
			GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $NAME.vcf >& $NAME.vcf.GRCh37.66.vcf.log
		#!# Eff.OutParsing.sh $1.Somatic.VEP.input.vcf.GRCh37.66.vcf

			AnnoVar.Annotation.sh $NAME.vcf.GRCh37.66.vcf 
			AnnoVar.Annotation.post1.sh
			AnnoVar.VarScanMergeAnnotation.Format.sh $NAME
		#####!!!!!VEP.sh $NAME.vcf.GRCh37.66.vcf

		fi

		cd ../..
		AnnoVarAnnotation.Report2Varscan.sh
else
		echo "VarScanAllMerge2Annotation.sh `find | grep snp$ | sort` &";
		usage " *.varscan.output.snp"
fi
