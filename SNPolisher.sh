#!/bin/sh

. ~/.bash_function

DefaultDIR=./
DIR=${1:-$DefaultDIR}

cd $DIR

if [ -f "AxiomGT1.calls.txt" ]; then

		# SNPolisher Run in the 93 serverxiomGT1.calls.txt

		ps-metrics --posterior-file AxiomGT1.snp-posteriors.txt --call-file AxiomGT1.calls.txt --metrics-file Output/metrics.txt

		ps-classification --species-type diploid --metrics-file Output/metrics.txt --output-dir Output
		#--ps2snp-file <file>


		ps-classification-supplemental --performance-file Output/Ps.performance.txt --summary-file AxiomGT1.summary.txt --call-file AxiomGT1.calls.txt --posterior-file AxiomGT1.snp-posteriors.txt --output-dir Output

		# http://media.affymetrix.com/support/developer/powertools/changelog/VIGNETTE-snp-polisher-apt.html


		(cd Output &&  R CMD BATCH --no-save --no-restore  ~/src/short_read_assembly/bin/R/Ps.performance.R)

else
	usage "./[directory]"
fi

