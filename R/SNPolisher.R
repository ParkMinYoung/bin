library("SNPolisher")
library("ggplot2")

# Ps_Metrics
ps.metrics <- Ps_Metrics(posteriorFile="AxiomGT1.snp-posteriors.txt",callFile="AxiomGT1.calls.txt",output.metricsFile="Output/metrics.txt")
 

# Ps_Classification
Ps_Classification(metrics.file="Output/metrics.txt", output.dir="Output", SpeciesType="Diploid")

ps.performance <- read.table("Output/Ps.performance.txt",header=T)


# Ps_Visualization
# Ps_Visualization(pidFile="Output/PolyHighResolution.ps", output.pdfFile="Output/Cluster_PolyHighResolution.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)
# Ps_Visualization(pidFile="Output/CallRateBelowThreshold.ps", output.pdfFile="Output/Cluster_CallRateBelowThreshold.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)
# Ps_Visualization(pidFile="Output/Hemizygous.ps", output.pdfFile="Output/Cluster_Hemizygous.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)
# Ps_Visualization(pidFile="Output/MonoHighResolution.ps", output.pdfFile="Output/Cluster_MonoHighResolution.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)
# Ps_Visualization(pidFile="Output/NoMinorHom.ps", output.pdfFile="Output/Cluster_NoMinorHom.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)
# Ps_Visualization(pidFile="Output/Other.ps", output.pdfFile="Output/Cluster_Other.pdf", summaryFile="AxiomGT1.summary.txt", callFile="AxiomGT1.calls.txt", confidenceFile="AxiomGT1.confidences.txt", posteriorFile="AxiomGT1.snp-posteriors.txt", temp.dir="Output/Temp", keep.temp.dir=FALSE, plot.prior=T, match.cel.file.name=TRUE, max.num.SNP.draw=100)

df<-read.table("Ps.performance.txt", header=T)

type<- as.data.frame( table(df$ConversionType )  )
type$Per<-(type$Freq/sum(type$Freq)*100)
colnames(type)<-c("ConversionType", "Count","Percent")

png("ConversionType.png", height=500, width=800)
ggplot(type, aes(reorder(ConversionType,Count), Count, fill=ConversionType)) + geom_bar(stat="identity") + geom_text(aes(y=Count, label=comma(sprintf("%1.2f %%", Percent))), vjust=-1, colour="blue", size=4) + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ scale_y_continuous(labels=comma) + xlab("ConversionType") + annotate("text", x=-Inf, y=Inf, label=paste("Total Marker", comma(sum(type$Count)), sep=" : "), size=5 , hjust=-.2, vjust=2, colour="blue") + geom_text(aes(y=0, label=comma(Count)), vjust=1.5, colour="darkorange", size=3) #+  ggtitle("SNPolisher : Marker Classicfication")

off.dev()

