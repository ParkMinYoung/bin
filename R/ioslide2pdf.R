args = commandArgs(trailingOnly=TRUE)

library(webshot)
library(rmarkdown)

rmdshot(args[1], args[2])

#print(args[1])
#print(args[2])
