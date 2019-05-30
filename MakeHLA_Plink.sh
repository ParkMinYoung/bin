#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2.bim" ]; then

	LIB=$1
	PLINK=$2

	LibraryAX2RS.sh $LIB
	plink2 --bfile $PLINK --chr 6 --update-name AX2RS --make-bed --out HLA --allow-no-sex --threads 1

else
	usage "Librarytab[Axiom_KORV1_1.na35.annot.csv.tab] Plink[AxiomGT1.calls.txt.extract.plink_fwd]"

fi



