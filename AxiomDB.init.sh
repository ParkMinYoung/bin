#!/bin/bash

. ~/.bash_function

DB=/home/adminrig/workspace.min/AFFX/AxiomDB.db
## init



if [ -f "$DB" ];then

	rm -rf $DB
fi


AxiomDB.create_KORV1_1_table.sh > create_KORV1_1_table.sql
sqlite3 $DB < create_KORV1_1_table.sql 

rm -rf create_KORV1_1_table.sql 

