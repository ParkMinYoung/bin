#!/bin/bash


for i in 0?????
	do 
	echo `date`, $i
	( cd $i && AxiomDB.run.bySet.sh /home/adminrig/workspace.min/AFFX/AxiomDB.db CEL/CELFile_information )
done
