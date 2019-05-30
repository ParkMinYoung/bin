

#x <- read.table(file = "clipboard", sep = "t", header=TRUE)
setwd("/home/adminrig/workspace.min/WGS.RICE.BEAN.Perilla")
df <- read.table("data", header =T ,sep="\t")

str(df)

#install.packages("GGally")
library(GGally)

png("WGS.2K.png", width=2000, height=2000)
ggpairs(data=df, columns=1:9, title="summary") # aesthetics, ggplot2 style
dev.off()

png("WGS.3K.png", width=3000, height=3000)
ggpairs(data=df, columns=1:9, title="summary") # aesthetics, ggplot2 style
dev.off()
