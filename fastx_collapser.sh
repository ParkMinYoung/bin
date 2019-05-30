#!/bin/sh
F=$1
zcat $F | fastx_collapser -i - -o $F.out.gz -z -Q33 -v >& $F.log

