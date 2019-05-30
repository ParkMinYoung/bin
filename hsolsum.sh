#!/bin/sh

source ~/.bash_function

if [ -d "$1" ];then

	NAME=$(basename $1)
	OUT=$(date +%Y%m%d).$NAME.summary.zip

	zip $OUT `find $1 -type f | egrep ".(css|htm|xml|gif|png)"$`

	CWD=$PWD

#EXP=$(echo $PWD | perl -nle'/\d{6}_\w{5}_\d+_\w+/;print $&')
	EXP=$(perl -le'print ${[split "\/",$ENV{PWD}]}[4]')
	DEST=$HOME/SolexaData/WetData/SOLEXA.Exp.dnalink/GA.hiseq

	DEST_DIR=$DEST/$EXP

	if [ ! -d "$DEST_DIR" ];then
		mkdir $DEST_DIR
	fi

	cp $OUT $DEST_DIR

else
		usage "alinged_dir" 
fi

