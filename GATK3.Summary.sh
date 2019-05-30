#!/bin/bash

. ~/.bash_function


if [ -d "$1" ] && [ $# -ge 2 ];then

		WES=$1
		SSV=$2

		# execute time : 2018-07-10 11:20:06 : link
		ln -s $WES/{*data,*report,*rtg.stat,*.selectsample.vcf} ./

		# for PDX
		reheader=( $(find ./ -maxdepth 1 -name "samples.dedup_metrics.data") )
		dedup=$WES/samples.reheader_metrics.data #samples.dedup_metrics.data
		[[ ! -f "$reheader" ]] && [[ -f "$dedup" ]] && ln -s $dedup samples.dedup_metrics.data

		# execute time : 2018-07-10 11:20:06 : vareval to table
		VCF=( $(find ./ -maxdepth 1 -name "*.vareval.report") )
		[[ -f "$VCF" ]] && GATK3.VariantEval2Table.sh $VCF

		# execute time : 2018-07-10 14:37:01 : get vcf stat
		RTG=( $(find ./ -maxdepth 1 -name "*rtg.stat") )
		[[ -f "$RTG" ]] && rtg.stat2Matrix.sh >  VCF.statistics

		# execute time : 2018-07-10 16:20:03 : make summary
		WES.data.summary.sh ./ $SSV > Summary.txt


		# execute time : 2018-07-10 16:20:03 : excel 
		TAB2XLSX.sh Summary.txt


		case $3 in 

			link) 
				echo "linking only symbolic files" ;;


			simple)
				echo "Report simple format" 
				
				# run to create report
				\cp -f /home/adminrig/src/short_read_assembly/bin/R/Report/WES/GATK3.Summary.simple.Rmd ./ && run.RMD.sh GATK3.Summary.simple.Rmd
				;;

			*)
				echo "Report whole format"

				# execute time : 2018-07-10 15:10:31 : Calc Conc using VCF files
				PairwiseCalcConcordantRateFromVCF.sh *.selectsample.vcf


				# run to create report
				\cp -f /home/adminrig/src/short_read_assembly/bin/R/Report/WES/GATK3.Summary.Rmd ./ && run.RMD.sh GATK3.Summary.Rmd
				;;

		esac

else

cat  <<EOF

samples.aligned.data
samples.dedup_metrics.data
samples.depthofcov.proportions.data
samples.reheader_metrics.data
XXX.selectsample.vcf
XXX.selectsample.vcf.rtg.stat
XXX.vareval.report


EOF

		usage "WES_DIR SSV[1..5] [link(only symlink),simple(Not Calc Conc)]"

fi



