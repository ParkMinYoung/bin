batch2.SGE.sh MeanQscore.Metrics.sh `ls *gz | sort` > 01.MeanQScore
sh 01.MeanQScore


waiting SRNA_S
#grep "^" *Metrics.txt | tr ":" "\t" > QscoreSummary.txt
ls *gz | sort | xargs -n 2 | perl -F'\s+' -anle'$f="$F[0].LinePerQScore.txt"; print "/home/adminrig/src/short_read_assembly/bin/MeanQscore.Metrics.Fastq.sh $_ $f"' | sh

ls *gz | grep 26 | perl -nle'print "qsub -N SRNA_S /home/adminrig/src/short_read_assembly/bin/sub /home/adminrig/src/short_read_assembly/bin/MeanQscore.Metrics.sh $_ $_\nsleep 10"' > 03.MeanQScore
sh 03.MeanQScore
waiting SRNA_S
#grep ^26 $(ls *MeanQscore.Metrics.txt | grep 26) > QscoreSummary.txt.26

MeanQscore.Metrics.Sumamry.sh $(ls *MeanQscore.Metrics.txt | grep -v 26) $(ls *MeanQscore.Metrics.txt | grep 26)  > QscoreSummary.txt.Total

