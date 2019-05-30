#!/bin/bash

. ~/.bash_function

if [ $# -eq 2 ] && [ -f "$2" ];then

		Target_DIR=$1
		Mapping_File=$2

		List=FileList.`date +'%Y%m%d'`

		# execute time : 2018-10-10 09:34:15 : get file list 
		find $Target_DIR -maxdepth 1 -mindepth 1 -type f | egrep "(ARR|JPG|DAT|CEL|AUDIT)"$ > $List


		# execute time : 2018-10-10 09:48:06 : make tab file
		cat $List | CELName.stdin.sh > $List.tab


		# execute time : 2018-10-10 10:03:52 : get target list 
		extract.h.sh $Mapping_File 1 $List.tab 3 > $List.Target


		# execute time : 2018-10-10 10:07:26 : add new id
		join.h.sh $List.Target $Mapping_File 3 1 2 > $List.Target.new


	## setting will bed created new directory 

		# execute time : 2018-10-10 10:05:10 : set orginal dir
		Dir_original=Dir_original.`date +'%Y%m%d'`


		# execute time : 2018-10-10 10:05:10 : set new dir
		Dir_rename=Dir_rename.`date +'%Y%m%d'`


		# execute time : 2018-10-10 10:10:16 : mkdir dirs
		mkdir $Dir_original $Dir_rename 

	## move file

		# execute time : 2018-10-10 10:12:30 : move to Dir_original.20181010
		tail -n +2 FileList.20181010.Target.new | cut -f4 | xargs -n 1000 -i mv {} $Dir_original 


		# execute time : 2018-10-10 10:13:26 : ln $Dir_original to $Dir_rename
		ln $Dir_original/* $Dir_rename 


	## make run script 

		# execute time : 2018-10-10 10:31:34 : make script
		perl -F'\t' -MMin -anle'if($.>1){ ($file, $newid) = (@F[5,7]);  $id=celname($file,1); $new_file = celname_substitute_id($file, $id, $newid); print "mv $file $new_file" }' $List.Target.new > $List.Target.new.script 


		# execute time : 2018-10-10 10:32:47 : run
		(cd $Dir_rename && sh ../$List.Target.new.script && ln * $Target_DIR)


else
		echo Mapping_File
		echo "two column"
		echo "1 : current id"
		echo "2 : new id"

		usage "Target_Directory Mapping_File"

fi

