library(pacman)
p_load(LDheatmap, rtracklayer, snpStats, GenABEL, coin)

data.dir <- '/home/adminrig/workspace.pyg/GWAS/array/Axiom_KORV1.0/2017/170327_Ehwa_KwonORan/Analysis/Analysis.5192.20170412/batch/2ndCall/Analysis/Analysis.5184.20170413/batch/plink/bymin'
out.dir <- data.dir                     # may want to write to a separate dir to avoid clutter


# Input files
gwas.fn <- lapply(c(bed='bed',bim='bim',fam='fam',gds='gds'), function(n) sprintf("%s/top1.LD.%s", data.dir, n))
geno <- read.plink(gwas.fn$bed, gwas.fn$bim, gwas.fn$fam, na.strings = ("-9"))



genotype <- geno$genotype
#print(genotype)                  # 861473 SNPs read in for 1401 subjects




#Obtain the SNP information from geno list
genoBim <- geno$map
colnames(genoBim) <- c("chr", "SNP", "gen.dist", "position", "A1", "A2")
#print(head(genoBim))



#```{r, fig.width=18, fig.height=15}

rgb.palette <- colorRampPalette(rev(c("blue", "orange", "red")), space = "rgb")

# Create LDheatmap
ld <- ld(genotype, genotype, stats="R.squared") # Find LD map of CETP SNPs

ll <- LDheatmap(ld, genetic.distances =genoBim$position, flip=TRUE, name="myLDgrob", title=NULL, color = rgb.palette(18))

# Add genes, recombination
llplusgenes <- LDheatmap.addGenes(ll, chr = "chr1", genome = "hg19", genesLocation = 0.01)
#```

