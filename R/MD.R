args <- commandArgs(TRUE)

library(knitr)
library(markdown)

setwd(args[1])
input<-args[3]
rmarkdown::render(args[2])

# https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/
# Rscript --vanilla /home/adminrig/src/short_read_assembly/bin/R/MD.R $PWD HLA.Rmd HLA_4dig.AnalysisResult.Conc.2digit &> HLA_4dig.AnalysisResult.Conc.2digit.log
