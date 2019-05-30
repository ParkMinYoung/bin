qstat -pri -u '*' | grep -w r > qstat.tmp
perl -F'\s+' -MMin -ane' $F[11]=~s/\@.+//; $h{$F[7]}{$F[11]}+=$F[12] }{ mmfss("qstat.tmp", %h)' qstat.tmp

qstat -g c > qstat.tmp.c
perl -F'\s+' -MMin -asne'if($.>2){ $h{AVAIL}{$F[0]}=$F[4]; $h{TOTAOL}{$F[0]}=$F[5] } }{ mmfss("qstat.tmp.c", %h)' qstat.tmp.c

MatrixMerge.v2.sh qstat.tmp.out qstat.tmp.txt qstat.tmp.c.txt
TAB2FixedLen.sh qstat.tmp.out.txt | perl -nle'BEGIN{ sub line { print "=" x (130) }; line(); } print; if($.==1){line()} if($.==3){ line()} }{ line()'

rm -rf qstat.tmp*


