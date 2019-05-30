#!/bin/bash

. ~/.bash_function


if [ -d "$1" ] & [ -f "$1/samples.dedup_metrics.data" ] & [ -f "$1/samples.aligned.data" ];then
	
	case $2 in 

	  SSV1 | ssv1 | 1 )
	    size=38753820
		;;
	  SSV2 | ssv2 | 2 )
	    size=46205186
		;;
	  SSV3 | ssv3 | 3 )
	    size=51542852
		;;
	  SSV4 | ssv4 | 4 )
	    size=51189318
		;;
	  SSV4U | ssv4U | 4U )
	    size=71256802
		;;
	  SSV5 | ssv5 | 5 )
	    size=50390601
		;;
	  SSV5QC | ssv5qc | 5qc )
	    size=50381058
		;;
	  SSV5U | ssv5U | 5U )
	    size=74569526
		;;
	  SSV6 | ssv6 | 6 )
	    size=60456963
		;;
	  SSV6U | ssv6U | 6U )
	    size=90697072
		;;
	  SSV6C | ssv6C | 6C )
	    size=65894148
		;;
	  SSV7 | ssv7 | 7 )
	    size=35804808
		;;
	  TrusightCancerPancel | tscp | 251  )
	    size=251096
		;;
	  Twist | twist | T  )
	    size=35804808
		;;
	  TW_V7 | tw_v7  )
	    size=29363444
		;;
	  * )
	    size=51542852
		;;

	esac


	cd $1
	join.h.sh samples.dedup_metrics.data samples.aligned.data 1 1 2..6 > step1
	join.h.sh step1 samples.depthofcov.proportions.subset.data 1 1 2..9 > step2

	perl -F'\t' -MMin -asnle'
	if($.==1){print "$_\tMeanDP\tOnTargetRate"}else{$DP=round($F[14]/$size,2); $onTargetRate= percent($F[14]/$F[12],2); @F[3,10,17..24] = map { percent($_,2) } @F[3,10,17..24]; print join "\t", @F, $DP, $onTargetRate }' -- -size=$size step2 > step3


	## check if exist *report.table from VCF & VCF.statistics

	VCF=( $(find -maxdepth 1 -name "*report.table") )
	
	if [ -f "$VCF" ];then

		join.h.sh step3 *report.table 1 1 2..15 > step4
		join.h.sh step4 VCF.statistics 1 1 "19..22,25,26"

	else

		cat step3

	fi



	## cleanup
	rm -rf step* 

else
	echo "cat ~/Genome/SureSelect/WES.Target/SureSelectTargetSize"

	usage "Directory SSV[1|2|3|4|4U|5|5U|6|6U|6C|7|Twist|TrusightCancerPancel]"

fi

