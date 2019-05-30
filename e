


#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] && [ $# -ge 2 ];then
        
        sed -n $2p $1 | bash 


elif [ $# -ge 1 ]; then
        
        README=readme
        file=${2:-$README}

        sed -n $1p $file | bash


else
        #(head ~/.bash_function; perl -nle'if(/^\s*\w+/){ print "echo \${RED}$_\${NORM}" }else{print "echo \${GREEN}$_\${NORM}" }' readme)  |  bash | cat -n
        cat -n readme
        usage "line_number[14] [readme]"
fi

