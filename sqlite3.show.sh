#!/bin/bash

. ~/.bash_function

if [ $# -eq 4 ] & [ -f "$3" ];then

	
	SQL="select * from $4 where $1 like \"%$2%\";"
	AxiomDB.createSQL.sh "$SQL" | sqlite3 $3 
	
#	AxiomDB.createSQL.sh "$SQL" > tmp.sql
#	sqlite3 $3 < tmp.sql 
#	rm -rf tmp.sql


else

	usage "COLUM_Name Query_String Database Table"

fi



