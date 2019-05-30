perl -F'\t' -MMin -ane'
chomp@F;
if(@ARGV){
    $t{$F[0]}++
}elsif(/^\d+:/){

	($chr,$type)=@F[1,2];
    if( $t{$F[0]} ){

        @tag = split /\|/, $F[4];
		unshift @tag, $F[0];    

        $h{$chr}{$type."_SNV"}++;
        $h{Total}{$type."_SNV"}++;

        @{$tag{$chr}}{@tag} = (1)x@tag;

    }
    $h{$chr}{Genome5MAFSNV}++;
    $h{Total}{Genome5MAFSNV}++;

}

}{

for $chr ( keys %tag ){

	$tagging_cnt = (keys %{$tag{$chr}})+0;
    $h{$chr}{TAG_SNV_Tagging}  = $tagging_cnt;

    $h{$chr}{GenomeCov} = sprintf "%.2f", ($tagging_cnt + $h{$chr}{NO_SNV})/$h{$chr}{Genome5MAFSNV} * 100;
    $h{Total}{TAG_SNV_Tagging} += $tagging_cnt;
	
#	print join "\n", keys %{$tag{$chr}};
}

$h{Total}{GenomeCov} = sprintf "%.2f", ( $h{Total}{TAG_SNV_Tagging} + $h{Total}{NO_SNV} ) / $h{Total}{Genome5MAFSNV} * 100;

mmfss("GenomeMAF5.Cov", %h)
' CommonSNP.Imputation_Tagging TaggingInformation.Rs2Loc
#' 22.CommonSNP.Imputation_Tagging 22.TaggingInformation.Rs2Loc



