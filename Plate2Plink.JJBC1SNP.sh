#!/bin/bash


cd $1/batch

LIB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab

ARGV=$2
L=${ARGV:-$LIB}

#perl -nle'next if /^cel/; s/\.\.\/\.\.\///; /.+_\d+{6}_\w{2,3}_(.+)\.CEL/; $id=$1; $id =~ s/_(2|3|4)$//; print "$_\t$id"' ../celfiles.txt > SAM
#sed -n '2,$ s/CEL\///g;'p ../celfiles.txt | awk '{print $1"\t"$1}' > SAM 
perl -MFile::Basename -nle'if($.>1){($f)=fileparse($_); print join "\t", $f, $f }' ../celfiles.txt > SAM
awk '{print $1"\t"$1}' $L > MARKER


/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh SAM MARKER AxiomGT1.calls.txt
/home/adminrig/src/short_read_assembly/bin/Num2Geno.Affy.sh $L AxiomGT1.calls.txt.extract > Genotype
/home/adminrig/src/short_read_assembly/bin/AddExtraColumn.sh Genotype $L 1 "3,5,6,7,8,10,14,15"
  
#/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract $L

