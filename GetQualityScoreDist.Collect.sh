#!/bin/sh
#Cols2Matrix.sh 5 Qscore `find | grep .Qscore$`
perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[4]}{ mmfsn("Qscore", %h)' `find | grep .Qscore$`

