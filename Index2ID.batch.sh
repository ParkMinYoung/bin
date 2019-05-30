#!/bin/sh

. ~/.bash_function

if [ -d "$1" ] && [ -f "mapping" ];then
	for i in $@;
		do
		cd $i
		INDEX=$(readlink -f ../mapping)
		ln $INDEX ./
		( cd Variant && unzip call.zip )
		Index2ID.sh
		cd ..
	done
else
	usage "dir_1 dir_2 ...."
fi


