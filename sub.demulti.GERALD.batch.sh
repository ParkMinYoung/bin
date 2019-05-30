#!/bin/sh


for i in `find 00? -maxdepth 1 -type d | grep GERALD`
    do cwd=$PWD
       NAME=GER.${i:0:3}
       echo $i && cd $i
       qsub -N $NAME ~/src/short_read_assembly/bin/sub.demulti.GERALD
       cd $cwd
       sleep 15
done


