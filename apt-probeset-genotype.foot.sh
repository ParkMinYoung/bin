#!/bin/bash

# 20180620 bymin
# insert cel information into db
DB=/home/adminrig/workspace.min/AFFX/AxiomDB.db

if [ -d "$1" ];then
	
	source $1/config
	AxiomDB.run.bySet.sh $DB CEL/CELFile_information  

elif [ -f "$1" ];then

	DB=$1
	AxiomDB.run.bySet.sh $DB CEL/CELFile_information  

else

	AxiomDB.run.bySet.sh $DB CEL/CELFile_information  

 #!#cat <<EOF
 #!#
 #!## ARGV  
 #!#
 #!#============================================================
 #!#
 #!#${RED}1. CEL Analysis default DIR${NORM} : /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1
 #!#${RED}1. AxiomDB.db${NORM} : /home/adminrig/workspace.min/AFFX/AxiomDB.db
 #!#
 #!#============================================================
 #!#
 #!#${GREEN}This script footer script that will be ran end of pipeline"${NORM}
 #!#
 #!#EOF
 #!#
 #!#	usage "/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1 or /home/adminrig/workspace.min/AFFX/AxiomDB.db" 

fi




