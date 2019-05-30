 perl -F'\t' -MList::Util=max,min -anle'
 $loc_digit = substr($F[4],0,3);
 $chr_strand = "$F[2]:$F[3]:$loc_digit";

 push @{ $h{$chr_strand}{$F[0]} }, @F[4,5];

 }{

 for my $chr ( keys %h ){
         my @genes = keys %{ $h{$chr} };
         for my $gene ( @genes ){
                 $min = min( @{ $h{$chr}{$gene} } );
                 $max = max( @{ $h{$chr}{$gene} } );
                 $chr =~ /chr\w+/;
                 print join "\t", $&, $min, $max, $gene;
         }
 } ' $1 > refFlat.Gene.bed

