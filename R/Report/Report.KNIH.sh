R -e 'library(knitr);library(markdown);rmarkdown::render("Report.KNIH.Rmd");' &> log
R -e 'library(knitr);knit("Report.KNIH.Rmd")' &> log

