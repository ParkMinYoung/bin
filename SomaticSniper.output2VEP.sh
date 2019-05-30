#perl -F'\t' -MMin -anle'BEGIN{%geno=iupac2genotype()}; print join "\t", @F[0,1,1],$geno{$F[3]},"+"' $1 > $1.VEP.input 
perl -F'\t' -MStatistics::Histogram -anle'

$key = "$F[0]:$F[1]";
if( !$h{$key}++ ){
	push @hist, $F[7];
	@var = split ",", @F[6];

	for $allele ( @var ){
		$value = join "\t", @F[0,1,1],"$F[5]/$allele","+";
		push @{$data{$F[7]}}, $value;
	}
}


}{print STDERR get_histogram(\@hist, 10, 0, 0);

for $i ( keys %data ){
	if ($i >= 5 ){
		map { print } @{$data{$i}};
	}
}
' $1 | sort | uniq 1> $1.VEP.input 2> $1.VEP.input.hist
#> $1.VEP.input 


##1  chr7
##2  158441657
##3  NCAPG2
##4  NM_017760
##5  intron-24
##6  T
##7  C
##8  3

