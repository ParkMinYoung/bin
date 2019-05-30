#!/bin/sh
cutadapt -m 18 -z -e 0.1 -q 10 -o $1.cutadapt			\
-b TACACTCTTTCCCTACACGACGCTCTTCCGATCT \
-b GAGCCGTAAGGACGACGACTTGGCGAGAAGGCTAG \
-b GATCGGAAGAGCGGTTCAGCAGGAATGCCGAG \
-b TCTAGCCTTCTCGCAGCACATCCCTTTCTCACAT \
-b AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
-b TTACTATGCCGCTGGTGGCTCTAGATGTGAGAAAGGGATGTGCTGCGAGAAGGCTAGA \
-b TCTAGCCTTCTCGCCAAGTCGTCCTTACGGCTCTGGCTAGAGCATACGGCAGAAGACGAAC \
-b AGATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG \
-b ACACTCTTTCCCTACACGACGCTCTTCCGATCT \
-b TCTAGCCTTCTCGCCAAGTCGTCCTTACGGCTCTGGC \
-O 5	 \
$1 >& $1.cutadapt.summary


# sanger 20 == illumina 51
#        10 ==          41

# Adapter 1		
# Adapter 2		
# PCR Primer 1		
# PCR Primer 2 		
# Sequencing Primer 1	
# Sequencing Primer 2	

# $1 is fastq or fastq.gz
# --rest-file=REST_FILE
# --overlap=3

