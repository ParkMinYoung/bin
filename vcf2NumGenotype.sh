for i in *vcf;do VCF2tabix $i;done
mkdir VCFMerge/
ls *vcf.gz | xargs vcf-merge > VCFMerge/merge.vcf

cd VCFMerge
vcf2Genotype.num.sh merge.vcf > merge.vcf.num

perl -F'\t' -anle'
BEGIN{
		$h{"0/0"}=-1;
		$h{"0/1"}=0;
		$h{"1/1"}=1;
		$h{"./."}=-2;
		$h{"."}=-2
}

@data = @F[6..$#F];

if($.==1){
	print join "\t", "Pos", @data 
}else{ 

	@num_geno = map { defined $h{$_} ? $h{$_} : -2 } @data;
	
	%geno = ();
	map { $geno{$_}++ } @num_geno;

	next if ( keys %geno )+0 == 1;

	print join "\t", "$F[0]_$F[1]", @num_geno;
} ' merge.vcf.num > merge.vcf.num.score


grep -v "\-2"  merge.vcf.num.score > merge.vcf.num.score.call

R CMD BATCH --no-save --no-restore '--args merge.vcf.num.score merge.vcf.num.score.call' ~/src/short_read_assembly/bin/R/Genotype2Heatmap.R
