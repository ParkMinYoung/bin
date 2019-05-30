#!/bin/sh

. ~/.bash_function

if [ -f "$1.bim" ]; then

	/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile ../AxiomGT1.calls.txt.extract.plink_fwd.gender --exclude /home/adminrig/workspace.min/AFFX/untested_library_files/KOR.RemoveMarker --make-bed --out $1 --allow-no-sex --threads 10
	tar cvzf $1.tar.gz $1.???
	cp $1.tar.gz /home/adminrig/workspace.min/211.174.205.50/temp

else
	"usage PLINK"
fi
