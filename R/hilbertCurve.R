source("http://www.bioconductor.org/biocLite.R")
library(HilbertVis)

H<-read.delim("Hiseq.KP_005.sample_interval_summary.table", header=T, sep="\t")
I<-read.delim("KP_005.SSV3.bam.AddRG.bam.Dedupping.Mark.bam.DepthCoverage.Report.sample_interval_summary.table", header=T, sep="\t")

H$chr<- factor(H$chr, labels=paste("chr", c(1:22,"X","Y"), sep=""))
I$chr<- factor(H$chr, labels=paste("chr", c(1:22,"X","Y"), sep=""))

base<-"white"
#base<-"black"
#high<-"red"
#low<-"blue"
high<-"green"
low<-"red"
max<-500


pdf("test.pdf", width=12, height=12)

image<- hilbertImage(H$mean_dp, level=8)

#showHilbertImage ( image, mode="lattice" )
showHilbertImage ( image, 
        palettePos = colorRampPalette(c(base, high))(300),
        paletteNeg = colorRampPalette(c(base, low))(300),
        maxPaletteValue = max,
mode="lattice" )

image<- hilbertImage(I$mean_dp, level=8)

#showHilbertImage ( image, mode="lattice" )
showHilbertImage ( image, 
        palettePos = colorRampPalette(c(base, high))(300),
        paletteNeg = colorRampPalette(c(base, low))(300),
        maxPaletteValue = max,
mode="lattice" )

image<- hilbertImage(H$mean_dp - I$mean_dp, level=8)

#showHilbertImage ( image, mode="lattice" )
showHilbertImage ( image, 
        palettePos = colorRampPalette(c(base, high))(300),
        paletteNeg = colorRampPalette(c(base, low))(300),
        maxPaletteValue = max,
mode="lattice" )



dev.off()



