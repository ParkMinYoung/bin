#!/bin/sh

. ~/.bash_function




if [ $# -eq 4 ];then

R1=$1
R2=$2
RG=$3
ID=$4

OUTPUT=$1.Tophat



tophat 										\
--output-dir $OUTPUT						\
--mate-inner-dist 150						\
--mate-std-dev 50							\
--solexa1.3-quals							\
--num-threads 2								\
--library-type fr-unstranded				\
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
$R1 $R2 

else
	usage "R1 R2 ReadGroup ID"
fi


# tophat reads1_1,reads2_1 reads1_2,reads2_2 	\
