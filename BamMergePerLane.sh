#!/bin/sh
find s_? | grep bam$ | xargs -n 2 | perl -nle'/s_\d/;print "samtools merge $&/$&.bam $_"'
