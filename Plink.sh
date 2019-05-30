#!/bin/sh

if [ -f "$1" ] & [ -f "$2" ];then

GetGenoFromCall.sh $1 $2
AddExtraColumn.sh $2.geno $1.Ref.new "2,3,4,5,6,7,8,9,10"
ExtractPlink.sh $1 $2.geno

else
	echo "$0 CsvAnnotationFile.v1.txt.tab.Ref.new AxiomGT1.calls.txt" 
	exit;
fi
