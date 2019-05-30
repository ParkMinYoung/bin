#!/bin/sh

ls AxiomHLA_4dig_*txt | perl -nle' /Axiom(.+)_Results.txt/; print "$1 $_"' | xargs -n 2 -P11 HLA_Analysis_Parsing.sh

# execute time : 2019-01-09 20:31:08 : merge
AddRow.w.sh HLA_4dig.AnalysisResult 'HLA_4dig_(.+).txt' Gene HLA_4dig_*.txt | grep AddRow | sh 


# execute time : 2019-01-09 20:31:29 : transform
ColCol2StrMatrix.sh 1 8 6 HLA.Gene HLA_4dig.AnalysisResult 


# execute time : 2019-01-09 20:35:31 : 
TABList2XLSX.v2.sh 1..12 HLA.Gene.txt HLA_4dig.AnalysisResult 


# execute time : 2019-01-09 20:35:53 : rename
mv TABList2.xlsx HLA.AnalysisResult.xlsx 


# cleanup
rm -rf HLA_4dig_*.txt
