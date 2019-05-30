#!/bin/sh
find s_?/ -type f | grep trimed$ | sort | xargs -i perl -nle'}{$r=$./4;print "$ARGV\t$r"' {} > trimmed.summary 

