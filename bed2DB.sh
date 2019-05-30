#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

DB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab.bed

/home/adminrig/src/bedtools/bedtools2/bin/bedtools intersect -wa -wb -f 1 -r -a $DB -b $1 > $1.out

echo -e "chr\tstart\tend\trsid\tgenotype" > $1.rsid
join.h.sh $1 $1.out  "1,2,3" "5,6,7" 4 | cut -d";" -f1,2 | tr ";" "\t" >> $1.rsid
TAB2XLSX.sh $1.rsid

rm -rf $1.rsid $1.out

else
	usage "XXX.bed"
fi

