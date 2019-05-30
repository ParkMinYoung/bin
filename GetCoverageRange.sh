#!/bin/sh
find s_? | grep Len$  | sort |  xargs perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfss("CoverageRange",%h)'
