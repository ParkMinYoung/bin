#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] && [ $# -eq 2 ];then

        perl -snle'push @l,$_;
        if($.%2==0){
                print join "\n",@l if length($_) >=$len;
                @l=()
        }' -- -len=$2 $1 > $1.over$2.fa

else
        usage "abyss.output.fa 100"
fi
