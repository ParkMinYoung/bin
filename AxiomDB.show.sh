#!/bin/bash

. ~/.bash_function



CMD_LIST=/home/adminrig/src/short_read_assembly/bin/AxiomDB.cmdlist


echo -e "\n\n"
_cyan $(LINE 80)

echo $(_red "command line DB : ") : $CMD_LIST

_cyan $(LINE 80)
echo -e "\n\n"




perl -nle'print ++$c, ". $_" ' $CMD_LIST

echo -e "\n\n"
echo ""
_bold "Type line number to execute the command you want to, followed by [ENTER]:"
echo ""
echo -e "\n\n"

read line

perl -snle'print if ++$c == $num ' -- -num=$line $CMD_LIST | sh 




