args <- commandArgs(trailingOnly=T)
		
library(pacman)
p_load(ggplot2, tidyr, dplyr, DT, readr, tibble, scales, sequenza)


data.file = args[1]
seqz.data <-read.seqz(data.file)


gc.stats <- gc.sample.stats(data.file)

gc.vect <- setNames(gc.stats$raw.mean, gc.stats$gc.values)
seqz.data$adjusted.ratio <- seqz.data$depth.ratio / gc.vect[as.character(seqz.data$GC.percent)]
test <- sequenza.extract(data.file)


CP.example <- sequenza.fit(test)
sequenza.results(sequenza.extract = test, cp.table = CP.example,
                 sample.id = args[2], out.dir=args[2])

cint <- get.ci(CP.example)

cellularity <- cint$max.cellularity
ploidy <- cint$max.ploidy
avg.depth.ratio <- mean(test$gc$adj[, 2])


cell_ploidy<- 
  data.frame( 
  	ploidy = cint$max.ploidy, 
	cellularity=cint$max.cellularity, 
	avg.depth.ratio = mean(test$gc$adj[, 2]))

write.table(cell_ploidy, paste(args[2], "Cellularity_Ploidy", sep="/") , sep="\t", row.names=FALSE, col.names=TRUE, quote = FALSE)
save(CP.example, file=paste(args[2], "CP.example.RData",sep="/"))

