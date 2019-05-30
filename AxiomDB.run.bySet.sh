#!/bin/bash

. ~/.bash_function

DB=$1
CEL_INFO=$2

if [ -f "$DB" ] & [ -f "$CEL_INFO" ];then

		sed '1 i\probeset_id\tcreate_date\tgrid_status\tserial_num\tbarcode\twell\tscanner\thyb_start_time\thyb_stop_time\thyb_fluidics_time\taccess_time\tmd5sum\tcelname' ./CEL/CELFile_information > step1

		AffyChipSummary.txt.sh ./

		join.h.sh step1 Summary.txt 1 1 "2,3,4,5,6,7,8,9,10,11,12" > step2

		# excute time : 2018-06-05 17:24:20 : add key
		perl -F'\t' -anle'if($.==1){ print "$_\tkey\ttimestamp" }else{ print "$_\t$F[0] $F[11]\t" }' step2 > step3

		# make insert SQL
		AxiomDB.insert.record.sh step3 > step4
		 
		sqlite3 $DB < step4

		# cleanup
		\rm -rf step? Summary.txt

else
		
cat <<EOF

# ARGV  

============================================================

${RED}1. AxiomDB.db${NORM} : sqlite3 database
${RED}2. CELFile_information${NORM} : CEL information

============================================================

${GREEN}This script insert records including CEL informations into DB(AxiomDB.db) using sqlite3${NORM}

EOF

		usage "/home/adminrig/workspace.min/AFFX/AxiomDB.db ./CEL/CELFile_information"
fi

