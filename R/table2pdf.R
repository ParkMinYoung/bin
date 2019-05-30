library(gridExtra)
hist(H$coverage, plot=FALSE)
count1<-cbind(H$breaks[-1], H$counts)
colnames(count1) <- c("CLASS","COUNT")

pdf(file="table.pdf")
grid.table(count1, show.rownames=FALSE)
dev.off()


