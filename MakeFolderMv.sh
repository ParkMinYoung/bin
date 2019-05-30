#!/bin/sh


source ~/.bash_function 


declare -a LIST
declare -a UNIQ_DIR 
declare -a FULLPATH_FILE 

if [ $# -eq 0 ];then
	usage "TargetDir FileList...."
fi


DEST_DIR=$1
shift 

if [ ! -d $DEST_DIR ];then
	mkdir -p $DEST_DIR
fi

FULL_DEST_DIR=$(fullpath $DEST_DIR)

if [ $# -ge 1 ];then

		LIST=$@
		#LIST=$(find a -type f)

		UNIQ_DIR=$( GetUniqDir.sh ${LIST[@]} )

		#echo ${UNIQ_DIR[@]}

		#(cd $DEST_DIR; rm -rf ${UNIQ_DIR[@]}; mkdir -p ${UNIQ_DIR[@]})
		(cd $DEST_DIR; mkdir -p ${UNIQ_DIR[@]})
		
		#echo $PWD
		#for i in ${UNIQ_DIR[@]};do echo $(fullpath $i);done

		for i in ${LIST[@]};
			do 
			Full_path_i=$(fullpath $i)
			DIR_i=$(dirname $i)
			FULLPATH_FILE=$(echo "$FULLPATH_FILE $Full_path_i")
			mv $Full_path_i $DEST_DIR/$DIR_i
			#echo "$Full_path_i $DEST_DIR/$DIR_i"
		done

else
	usage "TargetDir FileList...."
fi



