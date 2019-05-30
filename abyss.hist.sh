perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1] }{ mmfsn("InsertSize.hist",%h)' `ls *3.hist`
