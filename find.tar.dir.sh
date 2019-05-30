#find $1 -type f | perl -nle'print "qsub -N tar ~/src/short_read_assembly/bin/sub tar cjf $_.bz2 $_ && rm -rf $_"' > $1.excute.sh
find $1 -type f | perl -nle'print "qsub -N tar ~/src/short_read_assembly/bin/sub.rm tar cjf $_.bz2 $_"' > $1.excute.sh

