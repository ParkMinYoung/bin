find | grep $1 | perl -nle'print "qsub -N tar ~/src/short_read_assembly/bin/sub tar cjf $_.bz2 $_"' > $1.excute.sh



