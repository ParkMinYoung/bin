


mkdir ClusterReview.Double
ln -s `find $PWD/Analysis.* -type f | grep -e AxiomGT1.calls.txt$ -e AxiomGT1.summary.txt -e SAM$ ` ClusterReview.Double

cd ClusterReview.Double
grep -v ^AFFX $KORV1L | cut -f3 | sort | uniq -d | grep rs > RSId
grep -f RSId -w $KORV1L | cut -f1,3 > DoubleMarker

perl -F'\t' -anle'print join "\t", $F[0], "$F[1].$F[0]"' DoubleMarker  > MARKER
/home/adminrig/src/short_read_assembly/bin/ExtractSignal.v3.sh SAM MARKER AxiomGT1.calls.txt AxiomGT1.summary.txt

cd ClusterSignal
mkdir RsID
ls *png | sort |  perl -nle'/rs\d+/;push @{$h{$&}}, $_  }{ map { print "montage -font Helvetica -pointsize 20 -label \%f @{$h{$_}} -geometry 1000x800 -tile 2x1 RsID/$_.png" } sort keys %h' | sh
perl `which create_cluster_new.v2.pl` ClusterSignal.txt



 ##K=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.LeeKeunHo.v1_v2/Analysis/Analysis.1821.20150422/batch/keep_1735sam.txt
 ##perl -F"\t" -anle'if(@ARGV){$h{$F[0]}++}elsif($h{$F[1]}){print}' $K SAM  > SAM.Pass
 ##
 ##
 ##perl -F"\t" -anle'if(@ARGV){$h{$F[0]}++}elsif($h{$F[1]}){$F[0]=~s/rs\d+\.//; $_=join "\t",@F;print}' SAM.Pass ClusterSignal.txt > ClusterSignalPassSAM.txt
 ##
 ##
 ##perl `which create_cluster_new.v2.pl ` ClusterSignalPassSAM.txt
 ##rm -rf ClusterSignalPassSAM/AX-59878588.png
 ##
 ##zip ClusterSignalPassSAM.zip ClusterSignalPassSAM/*png

