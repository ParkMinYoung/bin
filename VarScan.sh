#!/bin/sh


source ~/.GATKrc


if [ $# -eq 0 ];then
	java $JMEM -jar $VarScan 
elif [ $# -eq 1 ];then
	java $JMEM -jar $VarScan $1 
fi

	exit 1


