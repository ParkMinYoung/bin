# /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.2015.GSK.v1/Analysis/Concordance

perl -F'\t' -MFile::Basename -anle'if(@ARGV){$h{$F[0]}=$F[1]}else{ ($f,$d)=fileparse($F[1]);  $F[4]-=5 if $h{$f} == 2; print join "\t", @F }' Sample.ControlCase ClusterSignal.txt > ClusterSignal.txt.CaseControl.txt

