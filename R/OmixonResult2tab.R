args <- commandArgs(TRUE)

library(pacman)
p_load(ggplot2, tidyr, dplyr, DT, readr, tibble, scales, ggrepel, gridExtra)

df <- read_tsv(args[1])

df %>% 
  select(-Allele) %>% 
  gather(Gene, Type, -1) %>% 
  filter( !is.na(Type) ) -> df1

write.table(df1, file="step1", quote=FALSE, sep="\t", row.names=FALSE, na=".")
