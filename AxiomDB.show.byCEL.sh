#!/bin/bash

. ~/.bash_function

if [ $# -eq 1 ];then

	SQL="select * from KORV1_1 where celname like \"%$1%\";"
	AxiomDB.createSQL.sh "$SQL" > tmp.sql

	sqlite3 /home/adminrig/workspace.min/AFFX/AxiomDB.db < tmp.sql 
	rm -rf tmp.sql


else

	usage "Axiom_KORV1_1_020060_A02"

fi



