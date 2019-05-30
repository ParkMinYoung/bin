perl -F'\t' -MMin -anle'
if($.==1){
    print join "\t", @F[0..47], qw/Genotype_type ID Genotype Forward_REF Reverse_REF Forward_ALT Reverse_ALT TotalDP ALT_Freq/;
    @header = @F;
}else{
    for $idx ( 48 .. 51 ){
        $genotype = $header[$idx];
        @sample = split ";", $F[$idx];
        if(@sample){
	    for $sam ( @sample ){
	        @list = split /\|/, $sam;
		($id, $geno) = split ":", $list[0];

		@F_var = $list[3] =~ /(\d+)/g;
		@R_var = $list[4] =~ /(\d+)/g;

		$var_depth = sum(@F_var, @R_var);
		$total_depth = sum( @list[1,2], $var_depth );
		$alt_freq    = sprintf "%.2f", $var_depth/$total_depth*100;

		print join "\t", @F[0 .. 47], $genotype, $id, $geno, @list[1..4], $total_depth, $alt_freq;
	    }
	}
    }
}' $1 
#}' merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT.Count > merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT.Count.PerVariant

