#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	def_NumOfFile=1000
	def_Threads=5
	FileList=$1
	NumOfFile=${2:-$def_NumOfFile}
	Threads=${3:-$def_def_Threads}

	# excute time : 2017-11-03 10:50:10 : split
	split -l $NumOfFile $FileList -d -a 2

	ls x?? | xargs -n 1 -P $Threads -i tar -cv -T {} -zf {}.tgz 

else
	usage "FileList [NumOfFile:1000] [Threads:5]"
fi



