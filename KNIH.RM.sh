find Project_KNIH.set* -type f | egrep -v "(fastqc.zip|fastq.gz|AddRG.ba(m|i)|Dedupping.ba(m|i))"$ | sort | xargs rm -rf
find Project_KNIH.set* -type d | egrep "(csv.stat|fastqc)"$ | sort | xargs rm -rf
