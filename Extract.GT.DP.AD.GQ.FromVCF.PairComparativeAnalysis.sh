#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	VCF=$1
	PAIR=$2

	DIR_default=PairComparativeAnalysis
	DIR=${3:-$DIR_default}

 	[ ! -d $DIR ] && mkdir $DIR
 
 	cwd=$PWD
 	VCF=$(readlink -f $VCF)
 	PAIR=$(readlink -f $PAIR)
		
	cd $DIR
 
 	while IFS=$'\t' read -r A B C; do
 		Extract.GT.DP.AD.GQ.FromVCF.sh $A $VCF
 		Extract.GT.DP.AD.GQ.FromVCF.sh $B $VCF
 		#echo $A $B
 		Extract.GT.DP.AD.GQ.FromVCF.PairComparativeAnalysis_PairJoin.sh $A $B
 	done < $PAIR
 
 	AddRow.w.sh PairComparativeAnalysis '(.+)' Pair $(ls | grep "\-\-\-") | grep ^Add | sh
 
 	ln -s $PWD/PairComparativeAnalysis $cwd


else
	usage "VCF PAIR_file"
fi

