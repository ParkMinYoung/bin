#!/bin/sh


for i in `find 0?? -maxdepth 1 -type d | grep GERALD`
    do cwd=$PWD
       NAME=GER.${i:0:3}
       echo $i && cd $i
       run.pl --runID=$NAME --projectDir=./CASAVA.$NAME -e $PWD -l 2 --applicationType=DNA --refSequences=/home/adminrig/Genome/Yeast/saccharomyces.cerevisiae --readMode single --snpCovCutoff=-1 -sgeAuto --sgeQueue all.q >& CASAVA.$NAME.log
       cd $cwd
done


