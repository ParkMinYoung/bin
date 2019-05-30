#!/bin/bash


# excute time : 2017-02-22 10:38:59 : step 1
#sh ShuffleGroupingFromListFile.wrapper.sh CEL_list 7000 {A..F}

. ~/.bash_function

if [ -f "$1" ];then

LIST_FILE=$1
shift

MAX=$1
shift

for i in $@; do ShuffleGroupingFromListFile.sh $LIST_FILE $i.shuffle $MAX; done 

# excute time : 2017-02-22 10:42:19 : step 2
MatrixMerge.v2.sh shuffle_input *shuffle.txt
rm -rf *shuffle.txt

else
	usage "List_file Max_value[100] file_list....."
fi


