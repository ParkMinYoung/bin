SeqSummary.sh
GenomeAnalysisTK.VariantEval.V4
ReadStatistics.ToAdd.Wrapper.sh



DIR=$(basename $PWD).structure
mkdir -p $DIR/{GCbias,InsertSize,Table}

mv FastqcInfo.txt SampleInfo.txt ProjectInfo.txt OVERLAP.summary.txt EVAL.summary.txt StatisticsReport.summary.txt $DIR/Table

cp `find Sample_* | grep -e gcbias.pdf.png$` $DIR/GCbias 
cp `find Sample_* | grep -e insertsize.pdf.png` $DIR/InsertSize

tar cvzf $DIR.tgz 
email.google.attach.sh minmin@dnalink.com "$DIR packing" "$DIR packing" $DIR.tgz



