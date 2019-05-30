#!/bin/sh

source ~/.bashrc
LINE=$(perl -le'print "="x80')

echo $LINE
echo "## Target directory For size : $#"
echo $LINE

for i in $@ ;do echo `date` `cd $i && du_e | tail -1 && cd ..` $i ;done

echo $LINE
