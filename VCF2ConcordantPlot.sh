#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

		  # VCF concordance
          python2.7 `which tb.py` concordance $1
  
          DIR=$(basename $1 .vcf)
          cd $DIR && ln -s ../Concordance_$DIR.VAR.txt
  
          R CMD BATCH --no-save --no-restore Concordance_$DIR.VAR.R
          mv *png ../ && cd ..

else
		usage "XXX.vcf"

fi

