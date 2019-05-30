#!/bin/bash

. ~/.bash_function

if [ -d "$1" ];then

	DIR=$1
	Target=$2

	[ ! -d $Target ] && mkdir $Target

	ln -s $DIR/AxiomGT1.calls.txt.extract.plink_fwd.gender.{bed,bim,fam,log} $DIR/{AxiomGT1.calls.txt,AxiomGT1.summary.txt,AxiomGT1.report.txt} $DIR/Output/Ps.performance.txt $Target

else	
	usage "Plink_DIR Target_DIR"
fi





