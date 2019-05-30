#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc

DIR=$( readlink -f $1 )
OPT="$2"
REF=${3:-$LR_b37_ref}

#echo "$@"

if [ -d "$DIR" ] && [ -d "$REF" ];then


	#DIR=$PWD/Rawdata/SNUH.KangByulChul.Pepper

	find $DIR 		| \
	grep I1_001 	| \
	perl -MFile::Basename -snle'
		$f=fileparse($_); 
		$f=~/(.+?)_S\d_L00/; 
		print "run_LR_wgs.sh DL_${1} $1 $dir \"$opt\" $ref"
	' -- -dir=$DIR -opt="$OPT" -ref=$REF

else

	usage "RawData_DIR \"--localcores=16 --localmem=192 --indices=SI-GA-A1 --uiport=3600\" [REF:$LR_b37_ref]"
fi


