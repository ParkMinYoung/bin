

OUT=AxiomGT1.report.`date +%Y%m%d`
#perl -F'\t' -anle'if(/^cel_file/ && $c==0){print "batch\t$_";$c++}elsif(/^Axiom/){print "$ARGV\t$_"}' ` find Axiom-batch-* -maxdepth 1 -type f| grep AxiomGT1.report.txt$ ` > AxiomGT1.report.`date +%Y%m%d`
perl -F'\t' -anle'if(/^cel_file/ && $c==0){print "batch\t$_";$c++}elsif(/^Axiom/){print "$ARGV\t$_"}' ` find  -maxdepth 1 -type f| grep AxiomGT1.report.txt$ ` > $OUT

#perl -F'\t' -anle'if($.==1){print "plate\t$_"}else{$F[1]=~/Axiom_soya_(\d+)_/;print "$1\t$_"}' $OUT > $OUT.plate
perl -F'\t' -anle'if($.==1){print "plate\t$_"}else{$F[1]=~/Axiom_Exome319_13-(\d+)_/;print "$1\t$_"}' $OUT > $OUT.plate
report2png.sh $OUT.plate


