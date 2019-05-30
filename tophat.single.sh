#!/bin/sh

. ~/.bash_function




if [ $# -eq 3 ];then

R1=$1
RG=$2
ID=$3

OUTPUT=$1.Tophat



tophat 										\
--output-dir $OUTPUT						\
--solexa1.3-quals							\
--num-threads 2								\
--GTF /home/adminrig/Genome/BOWTIE_INDEX/GTF/Sus_scrofa.Sscrofa9.64.gtf				\
--rg-id $RG     							\
--rg-sample $ID   							\
--rg-library DNALink.PE						\
--rg-description DNALink.Exp.RNAseq			\
--rg-platform-unit anymous					\
--rg-center DNALink.inc						\
--rg-date `date +%Y%m%d`					\
--rg-platform Illumina.Hiseq2000			\
/home/adminrig/Genome/BOWTIE_INDEX/susScr2	\
$R1  

else
	usage "R1 ReadGroup ID"
fi


# tophat reads1_1,reads2_1 reads1_2,reads2_2 	\
