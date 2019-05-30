 batch.SGE.sh AddOrReplaceReadGroups.sh `find Project_KNIH.set* | grep g.bam$ | egrep "Sample_(10|11|Pat)"` | perl -nle'$_.=" $1" if /Sample_(.+)?\//; print' > 09.ChageRG
