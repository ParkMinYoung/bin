perl -F'\t' -MMin -ane'
chomp@F;
if(@ARGV){
	$h{$F[0]} = $F[1];

}else{
	if(++$c == 1){
		map { $header{$F[$_]} = $_ } 0 .. $#F;
		@header= @F;
		
		for $i (sort keys %h){
			$A = $header{$i};
			$pair = $h{$i};
			$B = $header{$pair};
			print $A, $B, "\n";
			push @idx, [$A, $B];
		}
	}else{

		next if !/SNP/;

		for $i ( @idx ){
			($idx_A, $idx_B) = @{$i};
			$id = "$header[$idx_A] - $header[$idx_B]";
			
			$A = $F[$idx_A];
			$B = $F[$idx_B];


			if( $A ne $B && "$A$B" !~ /\./ ){
				next if "$F[3]$F[4]" =~ /,/;
				$geno = join " vs ", sort(@F[3,4]);
				$out{$geno}{$id}++;
				$out{Total}{$id}++;
			}
		}
	}
}

}{

	mmfss("VCF2PairMismatch", %out)
' $1 $2
#SamplePair 20150403_SMC_KimJinguk.SampleIDModified.vcf.num

R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/GenotypeCountPlot.R
