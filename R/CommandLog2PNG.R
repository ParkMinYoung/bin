args <- commandArgs(TRUE)

#R CMD BATCH --no-save --no-restore "--args $OUT" ~/src/short_read_assembly/bin/R/CommandLog2PNG.R

library(dplyr)
library(tidyr)
library(ggplot2)


setwd("/home/adminrig/workspace.min/CMD")
df<-read.table(args[1], header=T, sep="\t")
png1 = paste(args[1], "png", sep=".")


colnames(df)[1] = "command"
colnames(df) <- sub("X", "", colnames(df))
colnames(df) <- sub("211.174.205", "", colnames(df))

NewOrder<- as.character(df$command)
df<-select(df, -Total)
df$command<- factor( df$command, levels =  NewOrder )

cmd<-
  df %>%
  gather("ip", "count", 2:dim(df)[2])

png(png1, width=1200, height = 1120)
ggplot(cmd, aes(command, count, fill=command)) + geom_bar(stat="identity") + facet_grid(ip~.)
dev.off()

