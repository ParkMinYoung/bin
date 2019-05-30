
ln -s $1 Summary.txt.orginal

OrderedValueListFromKey.sh 2 1 8 Summary.txt.orginal

perl -F'\t' -anle'if(@ARGV){$F[2]=~/(.+);/;$h{$1}++}else{ if(++$cnt==1){print}elsif($h{$F[0]}){print} }' Summary.txt.orginal.OrderedValueListFromKey Summary.txt.orginal > Summary.Unique.txt

perl -F'\t' -anle'if(@ARGV){$F[2]=~/(.+);/;$h{$1}++}else{ if(++$cnt==1){print}elsif(!$h{$F[0]}){print} }' Summary.txt.orginal.OrderedValueListFromKey Summary.txt.orginal > Summary.Removed.txt

 perl -F'\t' -anle'print if $.==1; push @{$h{$F[1]}}, $_ }{ map {print join "\n", @{$h{$_}} if @{$h{$_}}>1 } sort keys %h' Summary.txt.orginal > Summary.Redundancy.txt

