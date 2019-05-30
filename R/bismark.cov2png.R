# R CMD BATCH --no-save --no-restore '--args 1_PgFib_ATGCCTAA_L008_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz' XXX.R

#setwd("/home/adminrig/workspace.min/MethylSeq/KonkukUniv_KoKinam/1_PgFib")
args <- commandArgs(TRUE)

library(ggplot2)
library(hexbin)

# filename<-"1_PgFib_ATGCCTAA_L008_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz"

filename<-args[1]


ID<-sub("_\\w{6,8}_L.+", "", filename, perl=T)
png1<-paste(ID, "png", sep=".")
png2<-paste(ID, "scatter", "png", sep=".")
png3<-paste(ID, "hexbin", "png", sep=".")

df<-read.table( gzfile(filename), header=F, sep="\t")


# source("http://bioconductor.org/biocLite.R")
# biocLite("hexbin")
# source("http://bioconductor.org/biocLite.R")
# biocLite()


df$DP<-df$V5+df$V6
#summary(df)

# ggplot(df, aes(DP, V4)) + stat_binhex() + xlim(c(0,500))


png(png1)
ggplot(df, aes(V4)) + stat_bin() + xlab("Methylation Percent(%)") + labs(title = ID)
dev.off()

png(png2)
ggplot(df, aes(DP, V4)) + geom_point(alpha = 1/10) + xlim(c(0,500)) + ylab("Methylation Percent(%)") + labs(title = ID)
dev.off()

png(png3)
ggplot(df, aes(DP, V4)) +  
  stat_binhex(bins = 60, colour="white") + 
  xlim(c(0,500)) + 
  ylim(c(1,99)) +
  ylab("Methylation Percent(%)") + 
  labs(title = ID) + 
  #scale_fill_continuous(breaks=seq(0,100000,500)) + 
  scale_fill_gradientn(colours=c("white","blue"),name = "Frequency",na.value=NA)

# ggplot(df, aes(DP, V4)) +  
#   stat_density_2d(contour=T, n=100) + 
#   xlim(c(0,500)) + 
#   ylab("Methylation Percent(%)") + 
#   labs(title = ID)
  
#  geom_point(alpha = 1/10) + 
dev.off()
