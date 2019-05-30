#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

        # faidx
        [ ! -f "$1.fai" ] && samtools faidx $1

        # make genome
        perl -F'\t' -anle'  $F[0]=~/^(\w+)/; print join "\t", $1, $F[1] '  $1.fai > $1.genome

        # make genome bed
        awk '{print $1"\t"0"\t"$2"\t"1"\t"1}' $1.genome > $1.bed 


#        faCount $1 > $1.nt_count


else

        usage "Genome.{fasta,fa}"

fi


