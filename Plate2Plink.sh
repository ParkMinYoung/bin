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
/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract $L



perl -F'\t' -anle'BEGIN{$s{male}=1;$s{female}=2;$s{unknown}=0} print join "\t", @F[0,0],$s{$F[1]} if /^Axiom/' AxiomGT1.report.txt > AxiomGT1.report.txt.gender
plink --bfile AxiomGT1.calls.txt.extract.plink_fwd --update-sex AxiomGT1.report.txt.gender --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender --noweb

plink --bfile AxiomGT1.calls.txt.extract.plink --maf 0.1 --geno 0.1 --hwe 0.001 --make-bed --out AxiomGT1.calls.txt.extract.plink.IBS.new --noweb
plink --bfile AxiomGT1.calls.txt.extract.plink.IBS.new --genome --out AxiomGT1.calls.txt.extract.plink.IBS --min 0.05 --thin 0.01 --noweb
R CMD BATCH --no-save --no-restore '--args AxiomGT1.calls.txt.extract.plink.IBS.genome ' ~/src/short_read_assembly/bin/R/IBS.scatterplot3d.final.R


