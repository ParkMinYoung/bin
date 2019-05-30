#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ $# -ge 3 ];then 

	op=${4:-"count"}

	datamash -s -H -g $2 $op $3 < $1

else	

cat <<EOF
 
_groupby_op.sh Summary.txt 1 1    			## groupby col 1 & count 
_groupby_op.sh Summary.txt 1 2 				## groupby col 1 & count 
_groupby_op.sh Summary.txt 1 2 mean			## groupby col 1 & mean col 2

EOF



	usage "Table Group_by_Column Value_Column Operation"
fi

