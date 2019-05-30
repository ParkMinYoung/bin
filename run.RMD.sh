#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	R=/home/adminrig/src/short_read_assembly/bin/R/run.RMD.R

	RMD=$1
	shift

	R CMD BATCH --no-save --no-restore "--args $RMD $@" $R

 ##	LINUX_VERSION=$(uname -r)

 ##	if [ $LINUX_VERSION == "2.6.32-279.14.1.el6.x86_64" ];then ## 93
 ##		
 ##		ssh -q -x 211.174.205.69 "cd $PWD && R CMD BATCH --no-save --no-restore \"--args $RMD $@\" $R"
 ##
 ##	elif [ $LINUX_VERSION == "2.6.32-642.4.2.el6.x86_64" ];then ## 69 server
 ##		
 ##		R CMD BATCH --no-save --no-restore "--args $RMD $@" $R
 ##		   
 ##	fi




else
	usage "XXX.Rmd [etc args list]"

	fi


