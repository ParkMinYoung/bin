#!/bin/sh

source ~/.bash_function
source ~/.GATKrc 

if [ $# -ge 2 ];then

	
	if [ -f "$1" ] && [ -f "$2" ];then
	Thread=$3
	SeedLen=$4
	MisMatch=$5

	T=${Thread:=4}
	S=${SeedLen:=32}
	M=${MisMatch:=2}

	# reference 
	# $REF come from .GATKrc	

	R1=$1
	R2=$2

	R1_trim=${R1/%.gz/}.trimed
	R2_trim=${R2/%.gz/}.trimed
	R1_single=${R1/%.gz/}.single	
	
	# trimming
	# illumina
	#!# Trim.pl --type 2 --qual-type 1 --pair1 $R1 --pair2 $R2 --outpair1 $R1_trim --outpair2 $R2_trim --single $R1_single
	# sanger 
#!#Trim.pl --type 2 --qual-type 0 --pair1 $R1 --pair2 $R2 --outpair1 $R1_trim --outpair2 $R2_trim --single $R1_single
 
     Q=20
     L=20
 
#sickle pe -f $R1 -r $R2 -q $Q -t illumina -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
	 sickle pe -f $R1 -r $R2 -q $Q -t sanger -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 


	fi

else
	usage "1.fastq{.gz} 2.fastq{.gz} [thread number 4] [seedlen 32] [mismatch 2]"
fi

