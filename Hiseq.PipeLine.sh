#!/bin/sh

source ~/.bash_function

# $1 samplesheet.csv
# $2 config.txt


if [ -f "$1" ] && [ -f "$2" ]; then

	SampleSheet=$1
	Config=$2

	Hiseq.BclToFastq.default.sh $SampleSheet UnAligned 16
	Hiseq.Alignment.sh UnAligned $Config 16

else
	usage "SampleSheet.csv Config.txt"
fi


