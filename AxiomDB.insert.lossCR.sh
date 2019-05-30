#!/bin/bash

. ~/.bash_function

if [ $# -eq 1 ];then

	## select CR==0
	AxiomDB.show.lossCR.sh $1 | cut -f15 | tail -n +2 | sort | uniq | sed 's/DL//' > lossCR

	if [ -s "lossCR" ];then
		## make sql
		perl -nle'print "delete from KORV1_1 where \"set\"=\"DL$_\";"' lossCR > lossCR.sql
		
		## removal record
		sqlite3 /home/adminrig/workspace.min/AFFX/AxiomDB.db < lossCR.sql
 
 
 		## insert recorde
		DIR=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis
 
		for i in $(cat lossCR); do (cd $DIR/$i && AxiomDB.run.bySet.sh /home/adminrig/workspace.min/AFFX/AxiomDB.db ./CEL/CELFile_information); done 
 
		## cleanup 
		rm -rf lossCR*
	else

		echo -e "\n"
		_green $(LINE 80)
		echo -e "\n"
		
		echo $(date)
		_bold "DB Records is the Best Status"
		
		echo -e "\n"
		_green $(LINE 80)
		echo -e "\n"
	fi


else

        usage "DL020"

fi

