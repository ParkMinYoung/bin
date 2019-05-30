#!/bin/bash

SendMessage()
{
    com=`tty`
    set `who am i`
    who | grep -v "$1" >filef.txt

    exec < filef.txt  
    array=""

    while read line
    do
        set $line
        echo $1
        array+=($1)
    done

    rm filef.txt
    exec <$com

    echo "====================>   Select User Number  <===================="
    echo

    select userName in ${array[@]} 
    do
        UserNam=$userName
        if [ -n $UserNam ]; then
            break
        fi
    done

    unset array #Clear the Array

    echo 
    echo

    echo "===================================> Message Body <==================================="

    mesg y
    read -p "put here your Message==> " messagel

    echo $messagel | write $UserNam

    if [ $? -eq 0 ]; then
        echo "It has been sent successfully.............ok"
        #return 0
    else
        echo "Message Failed to send ..............No!!"
        echo "Maybe It is not available for you To send Message To hem "
        return 1
    fi  
}

