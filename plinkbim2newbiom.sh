# perl -F'\t' -i.bak -aple'$F[1]= join ":", @F[0,3,4,5]; $_=join "\t", @F' $1 
perl -F'\t' -i.bak -aple'$F[1]= join ":", @F[0,3], sort( @F[4,5] ); $_=join "\t", @F' $1 
