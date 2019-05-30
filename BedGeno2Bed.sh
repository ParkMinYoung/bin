perl -F"\t" -anle'$geno="$F[3];$F[4]"; $g="$F[3]$F[4]"; $l=length($g); if($F[3] eq "-"){print join "\t", @F[0..2],$geno}else{print join "\t", $F[0],--$F[1],$F[2],$geno}' $1 
