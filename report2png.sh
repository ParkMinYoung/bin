#!/bin/sh

if [ -f "$1" ];then
	IN=$1
	R CMD BATCH --no-save --no-restore "--args $IN" ~/src/short_read_assembly/bin/R/report2png.R

else
	echo "$0 AxiomGT1.report.20131015.plate"
	exit 1
fi


