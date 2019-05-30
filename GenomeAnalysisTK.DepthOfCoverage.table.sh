perl -F'\t' -anle'if($.==1){print join "\t", qw/interval chr start end mean_dp/}else{$F[0]=~/(\w+):(\d+)-(\d+)/; print join "\t", $F[0], $1,$2,$3,$F[4]}' $1 > $1.table
