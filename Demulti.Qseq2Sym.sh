#!/bin/sh
for i in `find 0?? -maxdepth 0 -type d`;do echo $i && cd $i && Qseq2Sym.sh && cd ..;done

