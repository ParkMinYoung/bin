find s_? | egrep "fastq(.gz)?"$ | sort | xargs -n 2  | perl -nle'print "Trim2Bwa.sh $_ 3 &"'
# find s_? | egrep "fastq(.gz)?"$ | sort | xargs -n 2  | perl -nle'print "qsub -N Trim2BwaP ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh $_ 4\nsleep 20"'

