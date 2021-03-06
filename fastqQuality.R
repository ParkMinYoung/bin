#########################
## FASTQ Quality Plots ##
#########################
## Author: Thomas Girke
## Last update: 03-Mar-12
## Utility: 
##      Plots quality report for set of FASTQ files including 
##              (A) Per cycle box plot of quality
##              (B) Per cycle base proportion
##              (C) Per cycle mean base quality
##              (D) Relative k-mer diversity: unique_k-mers / all_possible_k-mers
##              (E) Number of reads where all Phred scores are above a minimum cutoff
##              (F) Distribution of mean quality of reads
##              (G) Read length distribution
##		(H) Read occurrence distribution

## (A) Compute quality stats and store them in list
seeFastq <- function(fastq, batchsize, klength=8) {
        require(ShortRead)
        require(Biostrings)
	
	## Processing of single fastq file
	.seeFastq <- function(fastq, batchsize, klength) { 
        	## Random sample N reads from fastq file (N=batchsize)
        	f <- open(FastqSampler(fastq, batchsize))
        	fq <- yield(f)
        	nReads <- f$status()[["total"]] # Total number of reads in fastq file
		close(f)
		
		## If reads are not of constant width then inject them into a matrix pre-populated with 
		## N/NA values and of dimensions N_rows = number_of_reads and N_columns = length_of_longest_read. 
		if(length(unique(width(fq))) == 1) {
        		q <- as.matrix(PhredQuality(quality(fq))) 
			s <- as.matrix(sread(fq))
		} else {
			mymin <- min(width(fq)); mymax <- max(width(fq))
			s <- matrix("N", length(fq), mymax)
			q <- matrix(NA, length(fq), mymax)
			for(i in mymin:mymax) {
				index <- width(fq)==i
				if(any(index)) {
					s[index, 1:i] <- as.matrix(DNAStringSet(sread(fq)[index], start=1, end=i))
					q[index, 1:i] <- as.matrix(PhredQuality(quality(fq))[index]) 
				}
			}
		}
		s[s=="N"] <- NA
        	row.names(q) <- paste("s", 1:length(q[,1]), sep=""); colnames(q) <- 1:length(q[1,])

        	## (A) Per cycle quality box plot
		## Generate box plot from precomputed stats	
		bpl <- boxplot(q, plot=FALSE)
		astats <- data.frame(bpl$names, t(matrix(bpl$stats, dim(bpl$stats))))
		colnames(astats) <- c("Cycle", "min", "low", "mid", "top", "max")
		astats[,1] <- factor(astats[,1], levels=unique(astats[,1]), ordered=TRUE)  
        
        	## (B) Per cycle base proportion
		bstats <- apply(s, 2, function(x) table(factor(x, levels=c("A", "C", "G", "T")))) 
        	colnames(bstats) <- 1:length(bstats[1,])
		bstats <- t(apply(bstats, 1, function(x) x/colSums(bstats)))
        	bstats <- data.frame(Nuc=rownames(bstats), bstats) 
        	convertDF <- function(df=df, mycolnames) { 
                                myfactor <- rep(colnames(df)[-1], each=length(df[,1]))
                                mydata <- as.vector(as.matrix(df[,-1]))
                                df <- data.frame(df[,1], mydata, myfactor)
                                colnames(df) <- mycolnames
                                return(df) 
                }
        	bstats <- convertDF(bstats, mycolnames=c("Base", "Frequency", "Cycle"))
        	bstats[,3] <- as.numeric(gsub("X", "", bstats[,3]))
        	bstats[,3] <- factor(bstats[,3], levels=unique(bstats[,3]), ordered=TRUE) 

        	## (C) Per cycle average quality of each base type
        	A <- q; A[s %in% c("T", "G", "C")] <- NA; A <- colMeans(A, na.rm=TRUE)
        	T <- q; T[s %in% c("A", "G", "C")] <- NA; T <- colMeans(T, na.rm=TRUE)
        	G <- q; G[s %in% c("T", "A", "C")] <- NA; G <- colMeans(G, na.rm=TRUE)
        	C <- q; C[s %in% c("T", "G", "A")] <- NA; C <- colMeans(C, na.rm=TRUE)
        	cstats <- data.frame(Quality=c(A, C, G, T), Base=rep(c("A", "C", "G", "T"), each=length(A)), Cycle=c(names(A), names(C), names(G), names(T)))
        	cstats[,3] <- factor(cstats[,3], levels=unique(cstats[,3]), ordered=TRUE) 

		## (D) Relative K-mer Diversity 
		dna <- sread(fq)
		loopv <- 1:(min(width(dna)) - (klength-1))
		kcount <- sapply(loopv, function(x) length(unique(DNAStringSet(start=x, end=x+klength-1, dna))))	
        	reldiv <- kcount/(5^klength) # 5 instead of 4 because of Ns
		reldiv <- c(rep(NA, klength-1), reldiv) # Adds dummy NAs to align with sequencing cycles 
		names(reldiv) <- 1:length(reldiv)	
        	dstats <- data.frame(RelDiv=reldiv, Method=rep(c(1), each=length(reldiv)), Cycle=names(reldiv))
        	dstats[,3] <- factor(dstats[,3], levels=unique(dstats[,3]), ordered=TRUE) 
        
		## (E) Number of reads where all Phred scores are above a minimum cutoff
                ev <- c("0"=0, "1"=10, "2"=20, "3"=30, "4"=40)
                edf <- sapply(ev, function(x) sapply(as.numeric(names(ev)), function(y) sum(rowSums(q >= x, na.rm=TRUE) >= (rowSums(!is.na(q))-y))))
		rownames(edf) <- names(ev); colnames(edf) <- ev
                edf <- edf/max(edf)*100
		edf <- data.frame(Percent=paste(">", colnames(edf), sep=""), t(edf), check.names=FALSE)
                estats <- convertDF(edf, mycolnames=c("minQuality", "Percent", "Outliers"))
		estats[,1] <- factor(estats[,1], levels=unique(estats[,1]), ordered=TRUE)
		estats[,3] <- factor(estats[,3], levels=unique(estats[,3]), ordered=TRUE)
		
		## (F) Distribution of mean quality of reads
		qv <- table(round(rowMeans(q)))[as.character(0:max(q, na.rm=TRUE))]
		qv[is.na(qv)] <- 0; names(qv) <- 0:max(q, na.rm=TRUE)
                fstats <- data.frame(Quality=names(qv), Percent=qv)
		fstats[,2] <- fstats[,2] / length(q[,1]) * 100
		fstats[,1] <- factor(fstats[,1], levels=unique(fstats[,1]), ordered=TRUE)
		
                ## (G) Read length distribution
                l <- rep(0, max(width(fq))); names(l) <- 1:length(l)
                lv <- table(width(fq))
                l[names(lv)] <- lv
                gstats <- data.frame(Cycle=names(l), Percent=l)
                gstats[,2] <- gstats[,2] / sum(gstats[,2]) * 100 
		gstats[,1] <- factor(gstats[,1], levels=unique(gstats[,1]), ordered=TRUE)

                ## (H) Read occurrence distribution
                qa1 <- qa(fq, basename(fastq))
                hstats <- qa1[["sequenceDistribution"]][,1:2]
                hstats <- data.frame(nOccurrences=hstats[,1], Percent=hstats[,1] * hstats[,2] / batchsize * 100)
		hstats[,1] <- factor(hstats[,1], levels=unique(hstats[,1]), ordered=TRUE)
	
		## Assemble results in list
		return(list(fqstats=c(batchsize=batchsize, nReads=nReads, klength=klength), astats=astats, bstats=bstats, cstats=cstats, dstats=dstats, estats=estats, fstats=fstats, gstats=gstats, hstats=hstats))
	}
	## Loop to run .seeFastq on one or many fastq files
	fqlist <- lapply(names(fastq), function(x) .seeFastq(fastq=fastq[x], batchsize=batchsize, klength=klength))
	names(fqlist) <- names(fastq)
	return(fqlist)
}
## Alias
fastqQuality <- seeFastq 

## (B) Plot seeFastq results 
seeFastqPlot <- function(fqlist, arrange=c(1,2,3,4,5,8,6,7), ...) {
	require(grid)
        require(ggplot2)
	
	## Create plotting instances from fqlist
	.fastqPlot <- function(x=fqlist) {
        	## (A) Per cycle quality box plot
		astats <- x[[1]][["astats"]]
		a <- ggplot(astats, aes(x=Cycle, ymin = min, lower = low, middle = mid, upper = top, ymax = max)) + 
			geom_boxplot(stat = "identity", color="#606060", fill="#56B4E9") +
                	scale_x_discrete(breaks=c(1, seq(0, length(astats[,1]), by=10)[-1])) + 
                	ylab("Quality") + 
                	opts(legend.position = "none", title = names(x), plot.title = theme_text(size = 12))
        	
        	## (B) Per cycle base proportion
		bstats <- x[[1]][["bstats"]]
		b <- ggplot(bstats, aes(Cycle, Frequency, fill=Base), color="black") + 
                	scale_x_discrete(breaks=c(1, seq(0, length(unique(bstats$Cycle)), by=10)[-1])) + 
               		geom_bar() + 
                	opts(legend.position="top", legend.key.size=unit(0.2, "cm")) + 
                	ylab("Proportion")  
        	
        	## (C) Per cycle average quality of each base type
		cstats <- x[[1]][["cstats"]]
		c <- ggplot(cstats, aes(Cycle, Quality, group=Base, color=Base)) + 
                	geom_line() + 
                	scale_x_discrete(breaks=c(1, seq(0, length(unique(bstats$Cycle)), by=10)[-1])) + 
                	opts(legend.position = "none")
        	
		## (D) Relative K-mer Diversity 
		dstats <- x[[1]][["dstats"]]
		d <- ggplot(dstats, aes(Cycle, RelDiv, group=Method, color=Method)) + 
			geom_line() + 
			scale_x_discrete(breaks=c(1, seq(0, length(unique(bstats$Cycle)), by=10)[-1])) + 
			ylab(paste("k", x[[1]][["fqstats"]][["klength"]], "-mer Div", sep="")) +
			opts(legend.position = "none")
                
		## (E) Number of reads where all Phred scores are above a minimum cutoff
		estats <- x[[1]][["estats"]]
		e <- ggplot(estats, aes(minQuality, Percent, fill = Outliers)) +
                        geom_bar(position="dodge") +
                	opts(legend.position="top", legend.key.size=unit(0.2, "cm")) + 
                        xlab("All Bases Above Min Quality") +
                        ylab("% Reads")
		
		## (F) Distribution of mean quality of reads
		fstats <- x[[1]][["fstats"]]
		f <- ggplot(fstats, aes(Quality, Percent)) +
                        geom_bar(fill="#0072B2") +
                        opts(legend.position = "none", 
                             title = paste(formatC(x[[1]][["fqstats"]][["batchsize"]], big.mark = ",", format="f", digits=0), "of", formatC(x[[1]][["fqstats"]][["nReads"]], big.mark = ",", format="f", digits=0), "Reads"), 
                             plot.title = theme_text(size = 9)) +
                        scale_x_discrete(breaks=c(0, seq(0, length(unique(fstats$Quality)), by=5)[-1])) +
                        xlab("Mean Quality") +
                        ylab("% Reads")
		
                ## (G) Read length distribution
		gstats <- x[[1]][["gstats"]]
		g <- ggplot(gstats, aes(Cycle, Percent)) +
                        geom_bar(fill="#0072B2") +
                        opts(legend.position = "none") +
                        scale_x_discrete(breaks=c(1, seq(0, length(unique(gstats$Cycle)), by=10)[-1])) +
                        xlab("Read Length") +
                        ylab("% Reads")
                
                ## (H) Read occurrence distribution
                hstats <- x[[1]][["hstats"]] 
                myintervals <- data.frame(labels=c("1", "2-10", "11-100", "101-1k", "1k-10k", ">10k"), lower=c(1,2,11,101,1001,10001), upper=c(2,11,101,1001,10001,Inf))
                iv <- sapply(seq(along=myintervals[,1]), function(x) sum(hstats[as.numeric(as.vector(hstats$nOccurrences)) >= myintervals[x,2] & as.numeric(as.vector(hstats$nOccurrences)) < myintervals[x,3], "Percent"]))
                hstats <- data.frame(labels=myintervals[,1], Percent=iv)
                hstats[,1] <- factor(hstats[,1], levels=unique(hstats[,1]), ordered=TRUE)
		h <- ggplot(hstats, aes(labels, Percent)) +
                        geom_histogram(fill="#0072B2") +
                        opts(legend.position = "none") +
                        xlab("Read Occurrence") +
                        ylab("% Reads")

		## Assemble results in list
		return(list(a=a, b=b, c=c, d=d, g=g, e=e, f=f, h=h))
	}
	## Loop to run .fastqPlot and store instances in list 
	fqplot <- lapply(names(fqlist), function(z) .fastqPlot(x=fqlist[z]))
	names(fqplot) <- names(fqlist)
	
	## Final plot
	grid.newpage() # Open a new page on grid device
	pushViewport(viewport(layout = grid.layout(length(arrange), length(fqplot)))) 
	for(i in seq(along=fqplot)) {
		for(j in seq(along=arrange)) {
			suppressWarnings(print(fqplot[[i]][[arrange[j]]], vp = viewport(layout.pos.row = j, layout.pos.col = i)))
		}
	}
}
## Alias
plotFQ <- seeFastqPlot

## Usage:
## Download some sample fastq files
# system("wget http://biocluster.ucr.edu/~tgirke/HTML_Presentations/Manuals/Rngsapps/chipseqBioc2012/data.zip")
# system("unzip data.zip")

## Generate FASTQ quality plots
# source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/fastqQuality.R")
# library(ggplot2)
# fastq <- list.files("data", "*.fastq$"); fastq <- paste("data/", fastq, sep="")
# names(fastq) <- paste("flowcell_6_lane", 1:4, sep="_")
# fqlist <- seeFastq(fastq=fastq, batchsize=100000, klength=8)
# pdf("fastqQuality.pdf", height=16, width=4*length(fastq))
# seeFastqPlot(fqlist, arrange=seq(along=fqlist))
# dev.off()






