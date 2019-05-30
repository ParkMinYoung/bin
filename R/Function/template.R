
---
params:
    dynamictitle: "NovaSeq vs. HiSeq<br>Duplicates Rate"
    reportdate: !r Sys.Date()
output: 
        html_notebook:
#         html_document:
         toc: true
         toc_float: true
         depth: 3
#         number_section: true
#         theme: readable
         theme: united
         highlight: tango
#         fig_caption: true
#         df_print: paged
#         df_print: tibble
#         df_print: kable
#         fig_caption: yes 
#         fig_retina: 1 
#         code_download: false
         
#kable
title: "`r params$dynamictitle`"
#date: "`r params$reportdate`"
author: Park MinYoung(minmin@dnalink.com) in BI, DNA Link
    
---

***

```{r setting, echo=FALSE, message=FALSE, warning=FALSE}
knitr::opts_chunk$set(echo=FALSE, message=FALSE, warning=FALSE, fig.width=7)
options(DT.options = list(pageLength = 10, language = list(search = 'Filter:')))
setwd("/home/adminrig/workspace.min/HiSeq_vs_NovaSeq")
source("/home/adminrig/src/short_read_assembly/bin/R/Min.R")
```

```{r library, include=FALSE}
library(pacman)
p_load(ggplot2, tidyr, dplyr, DT, scales, tibble, mosaic, UpSetR, purrr, readr, ggrepel)
options(knitr.table.format = "html") 

library(knitr)
library(kableExtra)
options(knitr.table.format = "html") 


# data_status()
# pkg_clean()
# rm(list=ls())
# http://rstudio.github.io/DT/extensions.html
```


<br>

# TEXT

<br>


<br>

# TEXT

<br>


<br>

# TEXT

<br>


<br>

# TEXT

<br>


