
perl -F'\t' -anle'if($.==1){print join "\t", qw/chr start end mean_dp above_15_pct/}else{$F[0]=~/(\w+):(\d+)-(\d+)/; print join "\t", $1,$2-1,$3,$F[4],$F[8]}' $1  
