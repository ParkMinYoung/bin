perl -F'\t' -MMin -ane'
chomp@F;
if(/^CountVariants/){
	if($F[1] eq "CompRod"){
		@header = @F;
		$ARGV =~ /vcf\.eval\.(.+)\.tab/;
		$id = $1;
	}else{
		$new="$id.$F[4]";
		
		map { $h{$new}{$header[$_]} = $F[$_] } (4,6..8,11,18..22);
		$h{$new}{nIndel} = sum @F[13..15];
	}
}elsif(/^VariantSummary/){
	if($F[1] eq "CompRod"){
		@header = @F;
	}else{
		$new="$id.$F[4]";

		map { $h{$new}{$header[$_]} = $F[$_] } (8);
	}
}
}{
	mmfss("eval.summary", %h)
' *.tab
