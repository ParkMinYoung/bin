#!/bin/bash

. ~/.bash_function

if [ $# -ge 2 ];then


BED=$1
shift

 # #cat << EOF
 # #genome hg19
 # #load myfile.bam
 # #snapshotDirectory mySnapshotDirectory
 # #EOF
 # #

echo "new"
echo "genome hg19"

for i in $@
	do 
	echo "load $i"
done

echo "snapshotDirectory ./"

while read chr start end gene etc
do
	cat << EOF
goto $chr:$start-$end
sort position
collapse
snapshot $gene.$chr.$start-$end.png
EOF

done < $BED

echo "exit"

else
	usage "target.bed XXX.{bam,bed,vcf,....} ...."
fi

# snapshot $gene.png
