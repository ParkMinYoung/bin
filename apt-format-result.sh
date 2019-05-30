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

L=$(LINE 80)

#Help function
function HELP {
echo "${BLUE}$L${NORM}"
echo "${GREEN}$L${NORM}"

  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${RED}Basic usage: ${BOLD}$SCRIPT file.ext${NORM}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${REV}-o${NORM}   Default is ${BOLD}output.vcf${NORM}."
  echo "${REV}-c${NORM}   Default is ${BOLD}AxiomGT1.calls.txt${NORM}."
  echo "${REV}-d${NORM}   Default is ${BOLD}Axiom_KORV1_1.na35.annot.db${NORM}."
  echo -e "${REV}-h${NORM}  Displays this help message. No further functions are performed."\\n
  echo -e "${BLUE}Example: ${BOLD}$SCRIPT -o XXX -f YYY -l ZZZ\n${NORM}"

echo "${GREEN}$L${NORM}"
echo "${BLUE}$L${NORM}"

echo "${MAGENTA}Version : 0.0.1${NORM}"
  exit 1
}

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
echo -e \\n"${BOLD}Number of arguments:${NORM} ${RED}$NUMARGS${NORM}"\\n
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.

echo -e "Command Line :${BOLD}$SCRIPT $@${NORM}"\\n

OUTPUT=output.vcf
CALL=AxiomGT1.calls.txt
DB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1.1/Axiom_KORV1_1.na35.annot.db

while getopts :o:c:d:h FLAG; do
  case $FLAG in
    o)  #set option "a"
      OUTPUT=$OPTARG
      echo "ouput vcf file name    : ${REV}$OPTARG${NORM}"
      ;;
	c)  #set option "f"
	  CALL=$OPTARG
	  echo "input calls.txt files  : $OPTARG"
	  ;;
	d)  #set option "l"
	  DB=$OPTARG
	  echo "input library db       : $OPTARG"
	  ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
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


apt-format-result --calls-file $CALL --annotation-file $DB --export-vcf-file $OUTPUT --snp-identifier-column Affy_SNP_ID


### Main loop to process files ###

#This is where your main file processing will take place. This example is just
#printing the files and extensions to the terminal. You should place any other
#file processing tasks within the while-do loop.


exit 0
