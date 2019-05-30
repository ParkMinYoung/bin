find s_? | grep fastq$ | xargs -n 2 | perl -nle'/s_\d/;print "qsub -N GATK.$& ~/src/short_read_assembly/bin/sub GATK.Pipeline.sh $_ $&\nsleep 20"'
