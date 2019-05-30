perl -F'\t' -MMin -anle'
next if /Hugo_Symbol/;
$F[2]=~s/`//;
$F[2]=~s/-/\./g;

$h{$F[0]}{$F[2]}{$F[7]}++;  
}{ 

for $sam( keys %h ){
   for $gene( keys %{$h{$sam}} ){

                $sam_cnt_per_gene{$gene}++;
                $mut_cnt_per_gene{$gene} += (keys %{ $h{$sam}{$gene} }) +0;

#print join "\t", $gene, $sam, (keys %{ $h{$sam}{$gene} }) +0;
    }
}

map { print join "\t", $_, $sam_cnt_per_gene{$_}, $mut_cnt_per_gene{$_}  } keys %sam_cnt_per_gene;
' $1 


