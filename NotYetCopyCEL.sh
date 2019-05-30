#!/bin/bash

. ~/.bash_function

DEST_DIR=$1
DIR=$2


if [ -d "$1" ] & [ -d "$2" ];then

		cd $DEST_DIR
		# $1 /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1
		# $2 /microarray/KORV1.1.v2


		echo -e "##################################################\n"
		echo `date` start time
		echo -e "##################################################\n"



		for i in $( find $DIR -maxdepth 1 -mindepth 1 -name "*.CEL" )
			do F=$(basename $i)
			[ ! -f $F ] && echo $i
		done > NotYetCopy  

		echo -e "##################################################\n"
		echo `date` start time
		echo -e "##################################################\n"

		 

		echo -e "##################################################\n"
		echo `date` CEL NotYetCopy Status
		echo -e "##################################################\n"

		 
		echo -e "##################################################\n"

		(echo -e "batch\twell\tid\tfile"; (cat NotYetCopy | CELName.stdin.sh)) | datamash -s -H -g 1 count 3
		 
		echo -e "##################################################\n"

		(echo -e "batch\twell\tid\tfile"; (cat NotYetCopy | CELName.stdin.sh)) | datamash -H count 1


		echo -e "##################################################\n"
		echo `date` Copy Start
		echo -e "##################################################\n"


		time cat NotYetCopy  | xargs -n 100 -P 10 -i cp {} ./


		echo -e "##################################################\n"
		echo `date` Copy End
		echo -e "##################################################\n"

else
		usage "Destination_dir Target_dir"
fi


