#!/bin/sh

#
#$ -cwd
#$ -v PATH
#$ -pe make 2 
#$ -j y
#$ -S /bin/bash
#$ -N ABYSS
#$
#

### $1 is kmer size ###


source ~/.bash_function

if [ $# -eq 1 ];then

DIR=abyss.$1
mkdir $DIR
cd $DIR

ln -s /home/adminrig/Polor.Plant.20110527/abyss/s_1.1.fastq /home/adminrig/Polor.Plant.20110527/abyss/s_1.2.fastq ./

abyss-pe k=$1 n=10  np=2 name=batch.$1 aligner=bwa \
lib="s_1" \
s_1="/home/adminrig/Polor.Plant.20110527/abyss/abyss.$1/s_1.1.fastq /home/adminrig/Polor.Plant.20110527/abyss/abyss.$1/s_1.2.fastq" \
g=batch.$1.graph

else
	usage "kmer-size[31]"
fi

