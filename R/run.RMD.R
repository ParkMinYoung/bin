library(knitr)

args <- commandArgs(trailingOnly=T)
rmd_file <- args[1]
 ### id<-args[1]
 ### group <- args[2]
 ### type <- args[3]
 ### model <- args[4]
 ### Name <- args[5]
 ### Gender <- args[6]
 ### Birth <- args[7]
 ### Casenum <- args[8]

rmarkdown::render(rmd_file)

