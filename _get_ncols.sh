#!/bin/bash
. ~/.bash_function


IN=${1:-/dev/stdin}
N=( $(awk '{print NF}' $IN | sort -nu | sed -n '1p;$p') ) 

# NF = Number of Fields


#echo ${N[@]}
#exit

if [ ${N[0]} -eq ${N[1]} ];then
	
	echo $N

else
	
	_echo "Minimum : $LowN, Maximum : $HighN"
	exit 1
fi

