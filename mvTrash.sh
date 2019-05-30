#!/bin/sh

. ~/.bash_function

D=TMP.`date +%Y%m%d`
mkdir $D
mv `find -type f  | egrep "(trimed|single|sai|sam.gz|(ing|fastq.gz|bration|sorted|ner).ba(i|m))"$` $D
