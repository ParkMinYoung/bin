#!/bin/sh

source ~/.bash_function


FILE=`which $1`

if [ -f "$FILE" ];then

        if [ -x $FILE ];then
                vim $FILE
        else
                echo "$FILE : permission error"
                usage excutable_file
        fi
else
        usage excutable_file
fi

