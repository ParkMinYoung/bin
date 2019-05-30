#!/bin/sh
perl -F'\t' -MMin -ane'chomp@F; $ARGV=~/s_\d/; $h{$F[0]}{$&}=$F[1] if $F[0]>0 }{ mmfsn("CovPerDept",%h)' `find s_? | grep Cov.txt `
