#!/bin/sh
cutadapt -e 0.2 -o $1.cutadapt			\
-a CAAGCAGAAGACGGCATACGA				\
-a GTTCAGAGTTCTACAGTCCGACGATC				\
-a TCGTATGCCGTCTTCTGCTTGT				\
-a ATCTCGTATGCCGTCTTCTGCTTG				\
-a CAAGCAGAAGACGGCATACGA				\
-a AATGATACGGCGACCACCGACAGGTTCAGAGTTCTACAGTCCGA		\
-a CGACAGGTTCAGAGTTCTACAGTCCGACGATC			\
-a GATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
-a CAAGCAGAAGACGGCATACGAGATCGGTCTCGGCATTCCTGCTGAACCGCTCTTCCGATCT \
$1 >& $1.cutadapt.summary

# $1 is fastq or fastq.gz
# --rest-file=REST_FILE
# --overlap=3

