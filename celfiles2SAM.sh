perl -nle'next if /^cel/; s/\.\.\/\.\.\///; /.+_\w+\d+_\w{2,3}_(.+)\.CEL/; $id=$1; $id =~ s/_(2|3|4)$//; print "$_\t$id"' $1 
