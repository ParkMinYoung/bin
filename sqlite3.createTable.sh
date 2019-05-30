#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ]; then

	sqlite3 $1 < $2

else
	
cat <<EOF

$(_bold ARGV)

$(_red "1. DB file  :") /home/adminrig/workspace.min/AFFX/AxiomDB.db
$(_red "2. sql file :") NGS.sql 
	
EOF


	usage "DB XXX.sql"
fi


