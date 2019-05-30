find s_? | grep fastq$ | xargs -n 2 | perl -nle'/s_\d/; $i="YS.$&"; print "qsub -N $i ~/src/short_read_assembly/bin/sub GATK.Pipeline.2.sh $_\nsleep 20"' 
