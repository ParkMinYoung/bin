#!/bin/bash

######################################################################
#This is an example of using getopts in Bash. It also contains some
#other bits of code I find useful.
#Author: Linerd
#Website: http://tuxtweaks.com/
#Copyright 2014
#License: Creative Commons Attribution-ShareAlike 4.0
#http://creativecommons.org/licenses/by-sa/4.0/legalcode
######################################################################

. ~/.bash_function


# http://tuxtweaks.com/2014/05/bash-getopts/

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Initialize variables to default values.
OPT_A=A
OPT_B=B
OPT_C=C
OPT_D=D

#Set Column Name
COLNAME=LABEL

#Help function
function HELP {
  _echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  _echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT file.ext${NORM}"\\n
  _echo "Command line switches are optional. The following switches are recognized."
  _echo "${REV}-o${NORM}  --Sets the value for option ${BOLD}o${NORM}. Default is ${BOLD}output${NORM}. Or stdout(standard output) or stderr(standard error)"
  _echo "${REV}-f${NORM}  --Sets the value for option ${BOLD}f${NORM}."
  _echo "${REV}-l${NORM}  --Sets the value for option ${BOLD}l${NORM}."
  _echo "${REV}-n${NORM}  --Sets the value for option ${BOLD}n${NORM} if file have noheader( -n 1 )."
  _echo "${REV}-x${NORM}  --Sets the value for option ${BOLD}x${NORM} not to remove header line will be excluded if file have # string starting line( -x 1 )."
  _echo "${REV}-t${NORM}  --Sets the value for option ${BOLD}t${NORM} instead of LABEL."
  _echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  _echo -e "Example: ${BOLD}$SCRIPT -o BlindPair.info -f \"BlindSampleList.info PairSampleList.info\" -l \"Blind Pair\""\\n${NORM}
  exit 1
}

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
_echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.

_echo -e "Command Line :${BOLD}$SCRIPT $@${NORM}"\\n

while getopts :o:f:l:t:n:h:x: FLAG; do
  case $FLAG in
    o)  #set option "a"
      OUTPUT=$OPTARG
	  if [ $OUTPUT == "stdout" ];then
	  	OUTPUT=/dev/stdout
	  elif [ $OUTPUT == "stderr" ];then
	  	OUTPUT=/dev/stderr
	  fi
      _echo "ouput file name : ${REV}$OPTARG${NORM}"
      ;;
	f)  #set option "f"
	  OPT_F=$OPTARG
	  _echo "input files     : $OPTARG"
	  set -f # disable glob
	  IFS=' ' # split on space characters
	  f_array=($OPTARG) # use the split+glob operator
	  ;;
	l)  #set option "l"
	  OPT_L=$OPTARG
	  _echo "input labels    : $OPTARG"
	  set -f # disable glob
	  IFS=' ' # split on space characters
	  l_array=($OPTARG) # use the split+glob operator
	  ;;
    x)  #set option "x"
      OK_sharp=$OPTARG
      _echo "input file have sharp string starting header : ${REV}$OPTARG${NORM}"
	  ;;
    n)  #set option "n"
      NOHEADER=$OPTARG
      _echo "input file don't have header : ${REV}$OPTARG${NORM}"
      ;;
    t)  #set option "t"
      COLNAME=$OPTARG
      _echo "column name : ${REV}$OPTARG${NORM}"
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      _echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###


### Main loop to process files ###

#This is where your main file processing will take place. This example is just
#printing the files and extensions to the terminal. You should place any other
#file processing tasks within the while-do loop.

NUM=${#f_array[@]}

_echo -e "\n\n========================================================"

for((i=0;i<=$NUM-1;i++))
	do
	FILE=${f_array[$i]}
	LABEL=${l_array[$i]}
	_echo " $((i+1)). ${BOLD}$FILE${NORM} is labeled ${BOLD}$LABEL${NORM}"
done 

_echo -e "========================================================\n\n"

#seq $NUM
if [ ${#f_array[@] } -eq ${#l_array[@] } ];then

	if [ ! -z  $NOHEADER  ];then
	
		 for((i=0;i<=$NUM-1;i++))
			do
			FILE=${f_array[$i]}
			LABEL=${l_array[$i]}
			LABEL=$(echo $LABEL | sed 's/\//\\\//g')
			#echo "$i $FILE $LABEL"
			grep -v ^# $FILE | sed "s/$/\t$LABEL/"  
		 done >> $OUTPUT
	else
		
		if [ ! -z $OK_sharp ];then

			#_echo $OK_sharp  # for # string starting with header line
		 	head -1 ${f_array[0]} | sed "s/$/\t$COLNAME/" > $OUTPUT
		else

		 	grep -v ^# ${f_array[0]} | head -1 | sed "s/$/\t$COLNAME/" > $OUTPUT
		fi

		 for((i=0;i<=$NUM-1;i++))
			do
			FILE=${f_array[$i]}
			LABEL=${l_array[$i]}
			LABEL=$(echo $LABEL | sed 's/\//\\\//g')
			#echo "$i $FILE $LABEL"
			grep -v ^# $FILE | tail -n +2 |  sed "s/$/\t$LABEL/"  
		 done >> $OUTPUT
	fi

fi

 
exit 0
