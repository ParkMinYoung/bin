mergeBed -i $1 -nms > $1.Merged.bed
GetBedLength.sh $1.Merged.bed > $1.size
perl -F'\t' -anle'$F[0]=~s/chr//;print "$F[0]:$F[1]-$F[2]" if $F[0]!~/_/' $1.Merged.bed > $1.intervals
# perl -F'\t' -anle'$F[0]=~s/chr//;print "$F[0]:$F[1]-$F[2]" if $F[0]!~/_/' $1 > $1.intervals
