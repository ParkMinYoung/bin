cat - | perl -MMath::Combinatorics -nle'push @vcf,$_ }{ map { ($A,$B)= @{$_}; print join "\t", $A, $B } combine(2, @vcf)'  
