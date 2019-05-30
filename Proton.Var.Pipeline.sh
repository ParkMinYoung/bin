#!/bin/sh

. ~/.bash_function

if [ -f "batch" ] && [ $# -eq 1 ];then

		FOLDER=VCF
		if [ ! -d "VCF" ]; then
				mkdir $FOLDER
		fi


		VCFLIST=VCFList.`date +%Y%m%d`
		XLSLIST=XLSList.`date +%Y%m%d`

		for i in `cat batch`;
				do
				find ../$i/Analysis/VAR -type f | grep vcf$ | xargs -i readlink -f {} | grep -v TSVC

		done > $VCFLIST

		for i in `cat batch`;
				do
				ls ../$i/Analysis/VAR/*/*.xls | xargs -i readlink -f {} 

		done > $XLSLIST




		perl -MFile::Basename -snle'
				/($dir_pattern\d+)/;
				($f)=fileparse($_);
				$folder="$desc/$1";
				mkdir $folder if ! -d $folder;
				print "ln -s $_ $folder" if ! -f "$folder/$f"
		' -- -desc=$FOLDER -dir_pattern=$1 $VCFLIST | sh




		# Folder
		VCFMerge=VCFMerge
		RawVCF=$VCFMerge/rawVCF

		mkdir -p $RawVCF && cp VCF/*/*vcf $RawVCF
		
		## removal of id's space
		#perl -F'\t' -i.bak -aple'if(/^#CHROM/){$F[9]=~s/ //g;$_=join "\t",@F}' $RawVCF/*.vcf

		for i in $RawVCF/*vcf;do VCF2tabix $i;done

		ls $RawVCF/*vcf.gz | xargs vcf-merge > $VCFMerge/merge.vcf

		ssh -q -x 211.174.205.93 "cd $PWD && batch.SGE.93.sh VCF2SNPEff3_6.sh VCFMerge/merge.vcf | sh"

		#### VCF Merge End
else
		usage "Ehwa_HeoJungWon.set[dir pattern]"
fi

