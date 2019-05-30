perl -F'\t' -MMin -ane'
chomp@F;
if(/^CountVariants/){
	if($F[1] eq "CompRod"){
		@header = @F;
	}else{
		$new=$F[3];
		
		map { $h{$new}{$header[$_]} = $F[$_] } (3,5..7,10,12..14,17..21,25,28);
		$h{$new}{nInDel} = sum @F[12..14];
	}
}elsif(/^CompOverlap/){
	if($F[1] eq "CompRod"){
		@header = @F;
	}else{
		$new=$F[3];

		map { $Overlap{$new}{$header[$_]} = $F[$_] } (3..9);
	}
}elsif(/^TiTvVariantEvaluator/){
	if($F[1] eq "CompRod"){
		 @header = @F;
	}else{
	 $new=$F[3];
	 map { $h{$new}{$header[$_]} = $F[$_] } (4..6);
	}
}
}{
@eval = qw/Sample
		nCalledLoci
		nRefLoci
		nVariantLoci
		nSNPs
		nInsertions
		nDeletions
		nComplex
		nInDel
		nNoCalls
		nHets
		nHomRef
		nHomVar
		nSingletons
		hetHomRatio
		insertionDeletionRatio
		nTi
		nTv
		tiTvRatio/;


@overlap = qw/Sample
		nEvalVariants
		novelSites
		nVariantsAtComp
		compRate
		nConcordant
		concordantRate/;


	mmfss_ctitle("EVAL.summary", \%h, \@eval);
	mmfss_ctitle("OVERLAP.summary", \%Overlap, \@overlap);
' $1 
#samples.analysisready.pass.vcf.EVAL.Sample.tab 
