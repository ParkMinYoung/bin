perl -F'\t' -anle'
if( $. == 1){
	@F[5,6,7] = ("Genotype", "NumOfReferenceAllele +/-", "NumOfAlternativeAllele +/-");
	print join "\t", @F;
}else{
	print jo
	
	@Format = split ":", $F[8];
	@Value  = split ":", $F[9];
	
	%data = ();
	map { $data{$Format[$_]} = $Value[$_] } 0 .. $#Format;

	$F[5] = $data{GT};
	$F[6] = "$data{SRF}/$data{SRR}";
	$F[7] = "$data{SAF}/$data{SAR}";
	@F[8..24] = @F[10..26];

	print join "\t", @F;
}' AnnoVarAnnotation.txt

