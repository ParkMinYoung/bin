#!/bin/sh
find s_? |grep -e [12].fastq$ -e trim -e single | perl -nle'/s_\d/;print "qsub -N $& ~/src/short_read_assembly/bin/sub tar cvjf $_.bz2 $_\nsleep 20"'

