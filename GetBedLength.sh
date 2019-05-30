#!/bin/sh
#awk '{s+=$3-$2}END{print s}' $1

echo "Original Bed Len"
getlenfrombed.sh $1


echo "Merged Bed Len";
bedtools sort -i SureSelect.MethylSeq.Regions.bed | bedtools merge -i stdin  -delim "," | getlenfrombed.sh
