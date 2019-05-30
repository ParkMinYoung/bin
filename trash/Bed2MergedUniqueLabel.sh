#perl -F'\t' -anle'if($.>1){$F[3]=~s/\.\d+//; print join "\t", @F[0..3]}' 
cut -f1-4 $1 | \
sortBed -i stdin | \
mergeBed -i stdin -nms | \
perl -F'\t' -anle'%h=();map{$h{$_}++} split ";",$F[3]; print join "\t", @F[0..2], (join ";", sort keys %h)' > $1.MergedUniqLabel.bed

