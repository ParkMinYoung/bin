#!/bin/sh

perl -F'\t' -MMin -ane'chomp@F;$h{$ARGV}{$F[0]}=$F[1] }{ mmfss("Q30Trim.log.stat",%h)' $@
