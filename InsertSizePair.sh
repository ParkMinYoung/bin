#perl -F'\t' -MMin -ane'chomp@F;if(/^MEDIAN_INSERT_SIZE/){$f=1;@head=@F}elsif(/^$/){$f=0}elsif($f && /^\d/){map{ $h{$head[$_]}{"$ARGV-$F[7]"} = $F[$_]} 0..6} }{mmfss("InsertSizePairCount",%h)' `find | grep CollectInsertSizeMetrics$`
perl -F'\t' -MMin -ane'chomp@F;if(/^MEDIAN_INSERT_SIZE/){$f=1;@head=@F}elsif(/^$/){$f=0}elsif($f && /^\d/){map{ $h{$head[$_]}{"$ARGV-$F[7]"} = $F[$_]} 0..6} }{mmfss("InsertSizePairCount",%h)' $@ 
#perl -F'\t' -MMin -ane'chomp@F;if(/^insert_size/){$f=1;@head=@F}elsif(/^($|#)/){$f=0}elsif($f && /^\d/){map{ $h{$F[0]}{"$ARGV-$head[$_]"} = $F[$_]} 1..$#F} }{mmfsn("InsertSizePairDist",%h)' `find | grep CollectInsertSizeMetrics$`
perl -F'\t' -MMin -ane'chomp@F;if(/^insert_size/){$f=1;@head=@F}elsif(/^($|#)/){$f=0}elsif($f && /^\d/){map{ $h{$F[0]}{"$ARGV-$head[$_]"} = $F[$_]} 1..$#F} }{mmfsn("InsertSizePairDist",%h)' $@ 

