#!/bin/sh

source ~/.bash_function

if [ $# -ge 1 ];then
	out=$1
	shift
	pdfmerge $@ $out 
	# pdfmerge.sh `sh GATK.pdf.Compare.sh $(find *stat | grep pdf | grep -v merge)`
else
	usage "output.pdf xxx.pdf yyy.pdf zzz.pdf ..."
fi
