perl -F'\t' -asnle'
BEGIN{
		$c=0;
		@eff_order = qw/
				SPLICE_SITE_ACCEPTOR
				SPLICE_SITE_DONOR
				SPLICE_SITE_REGION
				FRAME_SHIFT
				EXON
				GENE
				TRANSCRIPT
				EXON_DELETED
				NON_SYNONYMOUS_CODING
				NON_SYNONYMOUS_START
				RARE_AMINO_ACID
				START_LOST
				START_GAINED
				STOP_GAINED
				STOP_LOST
				CODON_CHANGE_PLUS_CODON_DELETION
				CODON_CHANGE_PLUS_CODON_INSERTION
				CODON_CHANGE
				CODON_DELETION
				CODON_INSERTION
				SYNONYMOUS_CODING
				SYNONYMOUS_STOP
				SYNONYMOUS_START
				INTRAGENIC
				INTERGENIC_CONSERVED
				UPSTREAM
				DOWNSTREAM
				UTR_3_PRIME
				UTR_3_DELETED
				UTR_5_PRIME
				UTR_5_DELETED
				INTRON
				INTRON_CONSERVED
				REGULATION
				INTERGENIC
				NONE
				CHROMOSOME
				CUSTOM
				CDS
				/;
		
		$order=0;
		map { $eff_order{$_}=$order++ } @eff_order;

if ( -f "gene" ){
	open $F, "gene" or die "cannot open gene file";
	while(<$F>){
		chomp;
		@F = split "\t", $_;
		$gene{$F[0]}++;
		$gene_flag++;
		print STDERR "read $F[0] $gene_flag";
	}
	close $F;
}

}

if(/^#/){
	if(/^##INFO=\<ID=(.+),Number=/){
		#print $1;
		$h{$1}=$c++;
	}
	@order = sort { $h{$a} <=> $h{$b} } keys %h;
#print ">>>\n\n";
#map { print join "\t", $_, $h{$_} } @order;
#print join " ", @order;
	$last_id = $1;

}else{

	if( $c ){
		@eff = qw/Effect Effect_Impact Functional_Class Codon_Change Amino_Acid_Change Amino_Acid_length Gene_Name Transcript_BioType Gene_Coding Transcript_ID Exon_Rank Genotype_Number/;
		print join "\t", qw/chr bp rs ref alt/, @order, @eff;
		$last_idx=$c-1;
		$c=0;
	}


	%hash = ();
	@out = ();
	$out[ $last_idx + 5 ]= "";


	@L = split ";", $F[7];
	map { /(.+)=(.+)/; $hash{$1}=$2; $eff=$_ if /EFF=/ } @L;

	@effs = split ",", $eff;

	
	%effect=();
	for $effect(@effs){
		$effect =~ /(\w+)\((.+)\)/;	
		($region,$remain)=($1,$2);
#print STDERR "$region\t$remain";

		if( $gene_flag ){
			 @detail = split /\|/ , $remain;
print STDERR $remain;
#print STDERR "[$detail[5]]" if  $gene{$detail[5]};
#print STDERR "[$detail[8]]" if  $gene{$detail[8]};
			$effect{$region} = $remain if $gene{$detail[5]}; # gene symbol
#$effect{$region} = $remain if $gene{$detail[8]}; # emsembl id
		}else{
			 $effect{$region} = $remain;
		}

	}
	
	@reorder_eff = sort { $eff_order{$a} <=> $eff_order{$b} } keys %effect;
	
	$high = $reorder_eff[0];
	@detail = split /\|/ , $effect{$high};



	map { $out[ $h{$_}+5 ] = $hash{$_} if $h{$_}  } keys %hash;
	
	@out[0..4]=@F[0..4];
	print join "\t", @out, $high, @detail[0..10];
#	print join "\t", @out, $high, $effect{$high}; 

		
}' $1 > $1.out
#}' try.vcf > try.vcf.out
