#!/bin/bash

. ~/.bash_function

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`


if [ $# -ge 4 ];then

OUTPUT=$1
shift
PATTERN=$1
shift
LABEL=$1
shift 


echo "output  :$OUTPUT"
echo "pattern :$PATTERN"
echo "label   :$LABEL"

#echo "step 3:$@"

FLIST=$(ls $@ | sort | tr "\n" " ")
LLIST=$(ls $@ | sort | perl -snle'/$pattern/; print $1' -- -pattern=$PATTERN | tr "\n" " ")

#echo $FLIST
#echo $LLIST

echo AddRow.sh -o $OUTPUT -f \"$FLIST\" -l \"$LLIST\" -t $LABEL -n 1

else
	echo -e "\n\n"
	echo -e "Example :$(basename $0) merge '(.+).indel'\ Analysis \*txt\n\n"	
	
	echo -e "AddRow.w.sh SomaticMutation '(.+).indel' Analysis \*txt  | grep Add | sh\n\n"

	usage "${BOLD}output_name perl_pattern label_name target_files${NORM}"

fi


