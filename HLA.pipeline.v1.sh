# excute time : 2017-07-21 15:21:56 : HLA step 1
 HLA_Analysis_Parsing.wrapper.sh 


# excute time : 2017-07-21 15:25:06 : HLA step 2
AddRow.sh -o HLA_4dig.AnalysisResult -f "HLA_4dig_A.txt HLA_4dig_B.txt HLA_4dig_C.txt HLA_4dig_DPA1.txt HLA_4dig_DPB1.txt HLA_4dig_DQA1.txt HLA_4dig_DQB1.txt HLA_4dig_DRB1.txt HLA_4dig_DRB3.txt HLA_4dig_DRB4.txt HLA_4dig_DRB5.txt" -l "A B C DPA1 DPB1 DQA1 DQB1 DRB1 DRB3 DRB4 DRB5" 


# excute time : 2017-07-21 16:01:49 : matrix
ColCol2StrMatrix.sh 1 8 6 HLA.Gene HLA_4dig.AnalysisResult


# excute time : 2017-07-21 16:05:08 : xlxs
TAB2XLSX.sh HLA_4dig.AnalysisResult && TAB2XLSX.sh HLA.Gene.txt


cp /home/adminrig/src/short_read_assembly/bin/R/Report/HLA_Axiom_Report/*Rmd ./ 


# Rmd2html
R -e 'library(rmdformats);library(rmarkdown);render("HLA_Analysis_Suite_Summary.v2.Rmd", "all");' &> rmd.log
R -e 'library(rmdformats);library(rmarkdown);render("HLA_Analysis_Suite_Summary.v2.Rmd", "pdf_document");' &> pdf.log
