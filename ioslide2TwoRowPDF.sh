#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then
		# R Setup
		# install.packages("webshot")
		# webshot::install_phantomjs()

		RMD=$1
		PDF=${RMD%.Rmd}.pdf

		Rscript --vanilla /home/adminrig/src/short_read_assembly/bin/R/ioslide2pdf.R $RMD $PDF &> $PDF.log 
		#R -e 'library(webshot);library(markdown); rmdshot("AAAA.Rmd", "BBBB.pdf")' &> log


		output=${PDF%.pdf}.1x2.slide.Rmd

cat <<EOF > $output
---
output: pdf_document
header-includes:
  - \usepackage{pdfpages}
papersize: a4paper
---

\`\`\`{r setup, include=FALSE}
knitr::opts_chunk\$set(echo = TRUE)
\`\`\`

\includepdf[pages={1-},scale=0.75, nup=1x2]{$PDF}

EOF

		run.RMD.sh $output

else
		usage "XXX.Rmd"
fi


# reference 
# https://stackoverflow.com/questions/51491454/how-do-i-convert-rmarkdown-ioslides-presentations-to-2-up-pdfs-programmatically
