#!/bin/sh

# usage : $0 fasta.name GENOME_ASSEMBLY SPECIES
# usage : CreateSequenceDictionary.sh hg18.fa hg18 human

# CreateSequenceDictionary
# $1 must be [XXX.fasta]
# output      XXX.dict
#             XXX.fasta.fai

source ~/.bash_function
GATK_param

NAME=$(echo $1 | sed s/\.fa.*//)

java -Xmx4g -jar $PICARDPATH/CreateSequenceDictionary.jar \
REFERENCE=$1				\
OUTPUT=$NAME.dict			\
GENOME_ASSEMBLY=$2			\
SPECIES=$2.$3				\
VALIDATION_STRINGENCY=LENIENT	\
MAX_RECORDS_IN_RAM=1000000		\
CREATE_MD5_FILE=true		




echo `date` samtools indexing ....
samtools faidx $1
cut -f1-2 $1.fai > $NAME.genome
perl -F'\t' -anle'print join "\t", $F[0],1,$F[1]' $NAME.genome > $NAME.target.bed

echo `date` bwa indexing ....

# if long fasta
bwa index -a bwtsw $1

# if short fasta
# bwa index -a is $1
