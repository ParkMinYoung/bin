# excute time : 2016-08-19 18:18:07 : step 1 : make MtManager input
for i in `find | grep vcf$`; do ExtractHVMut_MakeMTManagerInput.sh $i; done


# excute time : 2016-08-19 18:26:11 : output 1 : MTmanager input
perl -nle'print join "\t", $ARGV, $_' `find | grep list$` > MtManagerInput


# excute time : 2016-08-19 18:29:03 : output 2: SampleVarinatList.tab
perl -F'\t' -anle'if($.==1){ print "SAMPLE\t$_" }elsif(/^chrM/){print "$ARGV\t$_"}' `find | grep tab$` > SampleVarinatList.tab


